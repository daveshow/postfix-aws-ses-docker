FROM alpine:3.17

RUN sed -i 's,https://dl-cdn.alpinelinux.org,http://dl-4.alpinelinux.org,g' /etc/apk/repositories \
    && apk --update-cache --no-cache add \
    "ca-certificates=20211220-r0" \
    "cyrus-sasl-login=2.1.28-r0" \
    "libintl=0.21-r2" \
    "postfix=3.7.2-r0" \
    "rsyslog=8.2204.1-r0" \
    "supervisor=4.2.4-r0" \
    "lmdb=0.9.29-r1" \
    "tzdata=2022a-r0"

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
