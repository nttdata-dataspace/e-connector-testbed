#! /bin/bash
source .env || exit 1
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
           "counterPartyId": "'${MY_EDC_NAME}'",
           "counterPartyAddress": "http://'${MY_EDC_FQDN}':11003/api/v1/dsp",
           "protocol": "dataspace-protocol-http",
           "providerId": "'${MY_EDC_NAME}'",
           "offer": {
             "offerId": "'${OFFER_ID}'",
             "assetId": "asset-test-1",
             "policy": {
               "@type": "odrl:Set",
               "odrl:permission": {
                 "odrl:target": "asset-test-1",
                 "odrl:action": {
                   "odrl:type": "USE"
                 },
                 "odrl:constraint": {
                   "odrl:leftOperand": "REFERRING_CONNECTOR",
                   "odrl:operator": {
                     "@id": "odrl:eq"
                   },
                   "odrl:rightOperand": "http://another-connector"
                 }
               },
               "odrl:prohibition": [],
               "odrl:obligation": [],
               "odrl:target": "asset-test-1"
             }
           }
         }' \
     -X POST http://localhost:21002/api/management/edrs | jq
