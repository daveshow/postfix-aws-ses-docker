FROM alpine:3

RUN sed -i 's,https://dl-cdn.alpinelinux.org,http://dl-4.alpinelinux.org,g' /etc/apk/repositories \
    && apk --no-cache add \
    ca-certificates \
    cyrus-sasl-login \
    libintl \
    postfix \
    rsyslog \
    supervisor \
    lmdb \
    tzdata

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
