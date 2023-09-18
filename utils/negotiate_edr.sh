#! /bin/bash
if [ -z $1 ]; then
    exit 1
fi
OFFER_ID=$1

curl -s -H "X-Api-Key: ApiKeyDefaultValue" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
             "odrl": "http://www.w3.org/ns/odrl/2/"
           },
           "@type": "NegotiationInitiateRequestDto",
           "connectorAddress": "http://edc:11003/api/v1/dsp",
           "protocol": "dataspace-protocol-http",
           "connectorId": "my-connector-1",
           "providerId": "my-connector-1",
           "offer": {
             "offerId": "'${OFFER_ID}'",
             "assetId": "asset-test-1",
             "policy": {
               "@type": "odrl:Set",
               "odrl:permission": [],
               "odrl:prohibition": [],
               "odrl:obligation": [],
               "odrl:target": "asset-test-1"
             }
           }
         }' \
     -X POST http://localhost:21002/api/management/edrs | jq
