FROM alpine:3.20
# renovate: datasource=repology depName=alpine_3_20/ca-certificates versioning=loose
ENV CA_CERTIFICATES_VERSION=20240705-r0
# renovate: datasource=repology depName=alpine_3_20/cyrus-sasl-login versioning=loose
ENV CYRUS_SASL_LOGIN_VERSION=2.1.28-r6
# renovate: datasource=repology depName=alpine_3_20/libintl versioning=loose
ENV LIBINTL_VERSION=0.22.5-r0
# renovate: datasource=repology depName=alpine_3_20/postfix versioning=loose
ENV POSTFIX_VERSION=3.9.0-r1
# renovate: datasource=repology depName=alpine_3_20/rsyslog versioning=loose
ENV RSYSLOG_VERSION=8.2404.0-r0
# renovate: datasource=repology depName=alpine_3_20/supervisor versioning=loose
ENV SUPERVISOR_VERSION=4.2.5-r5
# renovate: datasource=repology depName=alpine_3_20/lmdb versioning=loose
ENV LMDB_VERSION=0.9.32-r0
# renovate: datasource=repology depName=alpine_3_20/tzdata versioning=loose
ENV TZDATA_VERSION=2024a-r1

RUN apk --update-cache --no-cache add \
    ca-certificates="${CA_CERTIFICATES_VERSION}" \
    cyrus-sasl-login="${CYRUS_SASL_LOGIN_VERSION}" \
    libintl="${LIBINTL_VERSION} "\
    postfix="${POSTFIX_VERSION}" \
    rsyslog="${RSYSLOG_VERSION}" \
    supervisor="${SUPERVISOR_VERSION}" \
    lmdb="${LMDB_VERSION}" \
    tzdata="${TZDATA_VERSION}"

ENV ACCEPTED_NETWORKS="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8" \
    RELAY_HOST="email-smtp.us-east-1.amazonaws.com" \
    RELAY_PORT="25" \
    RELAY_LOGIN="" \
    RELAY_PASSWORD="" \
    RECIPIENT_RESTRICTIONS="" \
    USE_TLS="yes" \
    TLS_VERIFY="may"

COPY files/ /
RUN chmod 755 /entrypoint.sh \
    && chmod 755 /usr/local/bin/supervisord-watchdog.py
ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord","--nodaemon","--configuration","/etc/supervisord.conf"]
