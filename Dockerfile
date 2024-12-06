FROM alpine:3.20

RUN \
    apk --update-cache --no-cache add \
        ca-certificates=20240705-r0 \
        cyrus-sasl-login=2.1.28-r6 \
        libintl=0.22.5-r0 \
        postfix=3.9.0-r1 \
        rsyslog=8.2404.0-r0 \
        supervisor=4.2.5-r5 \
        lmdb=0.9.32-r0 \
        tzdata=2024b-r0

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
