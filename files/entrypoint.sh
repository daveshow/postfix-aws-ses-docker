#!/bin/sh

set -e # exit on error

# Recipient restriction

	SMTPD_RECIPIENT_RESTRICTIONS="static:OK"
# shellcheck disable=SC2068,SC2086
	if [ -n "$RECIPIENT_RESTRICTIONS" ]; then
		SMTPD_RECIPIENT_RESTRICTIONS="inline:{$(echo ${RECIPIENT_RESTRICTIONS} | sed 's/\s\+/=OK, /g')=OK}"
	fi

# Relay SASL authentication

	RELAY_AUTH_ENABLE="no"
	RELAY_AUTH_PASSWORD_MAPS=""

	if [ "${RELAY_LOGIN}${RELAY_PASSWORD}" != "" ]
	then
		RELAY_AUTH_ENABLE="yes"
		RELAY_AUTH_PASSWORD_MAPS="static:${RELAY_LOGIN}:${RELAY_PASSWORD}"
	fi

# generating postfix config
	cat > /etc/postfix/main.cf <<-EOF
	# This is main.cf postfix file, for more details on configuration
	# see http://www.postfix.org/postconf.5.html

	# General configuration
	inet_interfaces = all
	inet_protocols = ipv4
	mynetworks = 127.0.0.0/8 [::1]/128 ${ACCEPTED_NETWORKS}

	# Relay configuration
	relayhost = ${RELAY_HOST}:${RELAY_PORT}
	smtp_sasl_auth_enable = ${RELAY_AUTH_ENABLE}
	smtp_sasl_password_maps = ${RELAY_AUTH_PASSWORD_MAPS}
	smtp_sasl_security_options = noanonymous
	smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
	smtp_tls_security_level = ${TLS_VERIFY}
	smtp_tls_session_cache_database = lmdb:\${data_directory}/smtp_scache
	smtp_use_tls = ${USE_TLS}

	# Disable "RCPT TO" restrictions
	smtpd_recipient_restrictions = ${SMTPD_RECIPIENT_RESTRICTIONS}, reject

	# Some tweaks
	biff = no
	mailbox_size_limit = 0
	readme_directory = no
	recipient_delimiter = +
	smtputf8_enable = no
	EOF

# Generate default postfix alias database
newaliases

# Pre-launch clean
# as we are in entrypoint, this means postfix cannot already be running
rm -f /var/spool/postfix/pid/*.pid

# Starting command
exec "$@"
