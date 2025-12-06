FROM alpine:3.23
# renovate: datasource=repology depName=alpine_3_23/ca-certificates versioning=loose
ENV CA_CERTIFICATES_VERSION="20251003-r0"
# renovate: datasource=repology depName=alpine_3_23/cyrus-sasl-login versioning=loose
ENV CYRUS_SASL_LOGIN_VERSION="2.1.28-r9"
# renovate: datasource=repology depName=alpine_3_23/libintl versioning=loose
ENV LIBINTL_VERSION="0.24.1-r1"
# renovate: datasource=repology depName=alpine_3_23/postfix versioning=loose
ENV POSTFIX_VERSION="3.10.7-r0"
# renovate: datasource=repology depName=alpine_3_23/rsyslog versioning=loose
ENV RSYSLOG_VERSION="8.2506.0-r0"
# renovate: datasource=repology depName=alpine_3_23/supervisor versioning=loose
ENV SUPERVISOR_VERSION="4.3.0-r0"
# renovate: datasource=repology depName=alpine_3_23/lmdb versioning=loose
ENV LMDB_VERSION="0.9.33-r0"
# renovate: datasource=repology depName=alpine_3_23/tzdata versioning=loose
ENV TZDATA_VERSION="2025b-r0"

RUN apk --update-cache --no-cache add \
    ca-certificates>"${CA_CERTIFICATES_VERSION}" \
    cyrus-sasl-login="${CYRUS_SASL_LOGIN_VERSION}" \
    libintl="${LIBINTL_VERSION}"\
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
