# Bareos director Dockerfile
FROM alpine:3.21

LABEL maintainer="aa@libertech.fr"

ARG BUILD_DATE
ARG NAME
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$NAME \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/barcus/bareos" \
      org.label-schema.version=$VERSION

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache bareos bareos-postgresql postgresql-client curl tzdata tar bash iputils-ping perl

RUN tar czf /bareos-dir.tgz /etc/bareos
RUN mv /etc/bareos/scripts /usr/lib/bareos/scripts
RUN mkdir /run/bareos \
 && chown bareos /run/bareos

COPY webhook-notify /usr/local/bin/webhook-notify
RUN chmod u+x /usr/local/bin/webhook-notify

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY sendEmail.pl /usr/bin/sendEmail.pl
RUN chmod u+x /docker-entrypoint.sh

EXPOSE 9101

VOLUME /etc/bareos
VOLUME /var/lib/bareos

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/bareos-dir", "-u", "bareos", "-f"]
