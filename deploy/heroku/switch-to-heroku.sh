DOMAIN=
TOKEN=


curl \
  -F "url=https://${DOMAIN}/api/v1/webhook" \
  https://api.telegram.org/bot${TOKEN}/setWebhook
