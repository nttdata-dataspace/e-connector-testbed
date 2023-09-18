#! /bin/bash
if [ -z $1 ]; then
    exit 1
fi
AGREEMENT_ID=$1

curl -s -H "X-Api-Key: ApiKeyDefaultValue" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
           },
           "@type": "TransferRequestDto",
           "connectorId": "another-connector",
           "connectorAddress": "http://edc:11003/api/v1/dsp",
           "contractId": "'${AGREEMENT_ID}'",
           "assetId": "asset-test-1",
           "protocol": "dataspace-protocol-http",
           "dataDestination": {
             "type": "HttpProxy"
           }
         }' \
     -X POST http://localhost:21002/api/management/v2/transferprocesses | jq
