#! /bin/bash
source .env || exit 1

curl -s -H "X-Api-Key: ApiKeyDefaultValue" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
           },
           "providerUrl": "http://'${MY_EDC_FQDN}':11003/api/v1/dsp",
           "protocol": "dataspace-protocol-http"
         }' \
     -X POST http://localhost:21002/api/management/v2/catalog/request | jq
