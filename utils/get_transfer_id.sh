#! /bin/bash
if [ -z $1 ]; then
    exit 1
fi
AGREEMENT_ID=$1

curl -s -H "X-Api-Key: ApiKeyDefaultValue" -H "Content-Type: application/json" \
     -X GET http://localhost:21002/api/management/edrs?agreementId=${AGREEMENT_ID} | jq
