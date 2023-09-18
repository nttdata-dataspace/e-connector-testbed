#! /bin/bash
if [ -z $1 ]; then
    exit 1
fi
POLICY_ID=$1

curl -s -H "X-Api-Key: ApiKeyDefaultValue" -H "Content-Type: application/json" \
     -d '{
           "@context": {
              "edc": "https://w3id.org/edc/v0.0.1/ns/",
              "odrl": "http://www.w3.org/ns/odrl/2/"
            },
            "@type": "NegotiationInitiateRequestDto",
            "connectorId": "another-connector",
            "connectorAddress": "http://edc:11003/api/v1/dsp",
            "consumerId": "another-connector",
            "providerId": "my-connector-1",
            "protocol": "dataspace-protocol-http",
            "offer": {
              "offerId": "'${POLICY_ID}'",
              "assetId": "asset-test-1",
              "policy": {
                "@id": "'${POLICY_ID}'",
                "@type": "odrl:Set",
                "odrl:permission": [],
                "odrl:prohibition": [],
                "odrl:obligation": [],
                "odrl:target": "asset-test-1"
              }
            }
         }' \
     -X POST http://localhost:21002/api/management/v2/contractnegotiations | jq
