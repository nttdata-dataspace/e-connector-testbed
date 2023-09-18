#! /bin/bash
source .env || exit 1

curl -s -H "X-Api-Key: ${EDC_API_AUTH_KEY}" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/",
             "odrl": "http://www.w3.org/ns/odrl/2/"
           },
           "@id": "policy-test-2",
           "policy": {
             "odrl:permission": [
               {
                 "odrl:action": {
                    "odrl:type": "USE"
                 },
                 "odrl:constraint": [
                   {
                      "odrl:leftOperand": "REFERRING_CONNECTOR",
                      "odrl:operator": {
                            "@id": "odrl:eq"
                      },
                      "odrl:rightOperand": "http://another-connector"
                   }
                ]
               }
             ]
           }
         }' \
     -X POST http://localhost:11002/api/management/v2/policydefinitions | jq
