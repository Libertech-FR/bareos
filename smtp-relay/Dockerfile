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
      org.label-schema.vcs-url="https://github.com/libertech-fr/postfix" \
      org.label-schema.version=$VERSION

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache  bash openssl postfix
COPY postfix_init.sh /postfix_init.sh
RUN chmod 755 /postfix_init.sh

EXPOSE 25

CMD ["/postfix_init.sh"]

HEALTHCHECK --interval=15s --timeout=10s --retries=3 CMD postfix status || exit 1

