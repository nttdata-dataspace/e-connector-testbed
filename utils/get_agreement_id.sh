#! /bin/bash
if [ -z $1 ]; then
    exit 1
fi
NEGOTIATION_ID=$1

curl -s -H "X-Api-Key: ApiKeyDefaultValue" -H "Content-Type: application/json" \
     -X GET http://localhost:21002/api/management/v2/contractnegotiations/${NEGOTIATION_ID} | jq
