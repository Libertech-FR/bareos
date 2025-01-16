#!/bin/bash
#

set -eo pipefail

echo "Configuring postfix with any environment variables that are set"

if [[ -n "${POSTFIX_MYNETWORKS}" ]]; then
    echo "Setting custom 'mynetworks' to '${POSTFIX_MYNETWORKS}'"
    postconf mynetworks="${POSTFIX_MYNETWORKS}"
else
    echo "Set 'mynetworks' to default"
    postconf mynetworks="127.0.0.1/32 172.0.0.0/8"
fi

if [[ -n "${POSTFIX_RELAYHOST}" ]]; then
    echo "Setting custom 'relayhost' to '${POSTFIX_RELAYHOST}'"
    postconf relayhost="[${POSTFIX_RELAYHOST}]:${POSTFIX_RELAYHOST_PORT}"
else
    echo "Set 'relayhost' to default (unset)"
    postconf -# relayhost
fi

echo "Disable chroot for the smtp service"
postconf -F smtp/inet/chroot=n
postconf -F smtp/unix/chroot=n

if [[ "${POSTFIX_INETPROTOCOLS}" = "all" ]]; then
    echo "Enabling IPv4 and IPv6"
    postconf inet_protocols="all"
elif [[ "${POSTFIX_INETPROTOCOLS}" = "ipv6" ]]; then
    echo "Enabling IPv6"
    postconf inet_protocols="ipv6"
elif [[ "${POSTFIX_INETPROTOCOLS}" = "ipv4, ipv6" ]]; then
    echo "Enabling IPv4 and IPv6"
    postconf inet_protocols="all"
elif [[ "${POSTFIX_INETPROTOCOLS}" = "ipv4" ]]; then
    echo "Enabling IPv4"
    postconf inet_protocols="ipv4"
else
    echo "Enabling IPv4"
    postconf inet_protocols="ipv4"
fi

#echo "Disable ipv6"
#postconf inet_protocols="ipv4"

if [[ "${POSTFIX_TLS}" = "true" ]]; then
    echo "Configuring TLS"
    postconf smtp_tls_CAfile="/etc/ssl/certs/ca-certificates.crt"
    postconf smtp_tls_security_level="encrypt"
    postconf smtp_use_tls="yes"
    postconf smtp_tls_wrappermode="yes"
fi

if [[ -n "${POSTFIX_SASL_AUTH}" ]]; then
    echo "Configuring SASL Auth"
    if [[ -z "${POSTFIX_RELAYHOST}" || -z "${POSTFIX_TLS}" ]]; then
        echo "Please set 'POSTFIX_RELAYHOST' AND 'POSTFIX_TLS' before attempting to enable SSL auth."
        exit 1
    fi

    postconf smtp_sasl_auth_enable="yes"
    postconf smtp_sasl_password_maps="lmdb:/etc/postfix/sasl_passwd"
    postconf smtp_sasl_security_options="noanonymous"
    postconf smtp_tls_note_starttls_offer="yes"
    # generate the SASL password map
    echo "${POSTFIX_RELAYHOST} ${POSTFIX_SASL_AUTH}" > /etc/postfix/sasl_passwd

    # generate a .db file and clean it up
    postmap lmdb:/etc/postfix/sasl_passwd && rm /etc/postfix/sasl_passwd

    # set permissions
    chmod 600 /etc/postfix/sasl_passwd.lmdb
fi
postconf maillog_file=/var/log/postfix.log
postconf maillog_file_permissions=0644

echo "Starting postfix"
postfix start-fg
