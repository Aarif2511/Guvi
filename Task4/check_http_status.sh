#! /bin/bash

echo "Enter the URL:"

read URL

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
echo "Success! HTTP Status Code: $HTTP_CODE"
else
echo "Failure! HTTP Status Code: $HTTP_CODE"
fi
