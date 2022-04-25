# postfix-aws-ses-docker
## Available ENV variables and their default values

| Variable               | Defaul value                            | Description                                                  |
| ---------------------- | --------------------------------------- | ------------------------------------------------------------ |
| ACCEPTED_NETWORKS      | 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8 | Network who can send email through this SMTP relay           |
| RELAY_HOST             | email-smtp.us-east-1.amazonaws.com      | SMTP relay host                                              |
| RELAY_PORT             | 25                                      | SMTP relay port (should be 25, 465 or 587)                   |
| RELAY_LOGIN            | *none*                                  | Username used in SASL authentication                         |
| RELAY_PASSWORD         | *none*                                  | Password used in SASL authentication                         |
| RECIPIENT_RESTRICTIONS | *none*                                  | See http://www.postfix.org/postconf.5.html#smtpd_recipient_restrictions |
| USE_TLS                | yes                                     | Enable TLS with SMTP relay (yes or no)                       |
| TLS_VERIFY             | may                                     | See http://www.postfix.org/postconf.5.html#smtp_tls_security_level |
