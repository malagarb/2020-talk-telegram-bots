CHAT_ID=
TOKEN=


curl -X POST \
     -H 'Content-Type: application/json' \
     -d "{\"chat_id\": \"${CHAT_ID}\", \"text\": \"This is a test from curl\", \"disable_notification\": true}" \
     https://api.telegram.org/bot${TOKEN}/sendMessage
