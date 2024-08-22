#! /bin/bash
source .env || exit 1
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
            "@type": "ContractRequest",
            "counterPartyAddress": "http://edc:11003/api/v1/dsp",
            "protocol": "dataspace-protocol-http",
            "policy": {
              "@context": "http://www.w3.org/ns/odrl.jsonld",
              "@id": "'${POLICY_ID}'",
              "@type": "Offer",
              "assigner": "'${MY_PARTICIPANT_ID}'",
              "target": "asset-test-1"
            }
         }' \
     -X POST http://localhost:21002/api/management/v3/contractnegotiations | jq
