DOMAIN=
TOKEN=


curl \
  -F "url=https://${DOMAIN}:8443/api/v1/webhook" \
  -F "certificate=@PUB.pem" https://api.telegram.org/bot${TOKEN}/setWebhook
