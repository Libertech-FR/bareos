# Dockerfile Bareos storage daemon
FROM arm32v7/alpine:3.17.0

LABEL maintainer="barcus@tou.nu"

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

RUN sed -i 's|https://dl-cdn.alpinelinux.org/alpine/v3.[^/]*\/|https://dl-cdn.alpinelinux.org/alpine/edge/|' /etc/apk/repositories

RUN apk add --no-cache bareos bareos-storage tar

RUN tar czf /bareos-sd.tgz /etc/bareos/bareos-sd.d
RUN mkdir /run/bareos \
      && chown bareos /run/bareos

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

EXPOSE 9103

VOLUME /etc/bareos
VOLUME /var/lib/bareos/storage

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/bareos-sd", "-u", "bareos", "-f"]
