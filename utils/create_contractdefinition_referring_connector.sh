#! /bin/bash
source .env || exit 1

curl -s -H "X-Api-Key: ${EDC_API_AUTH_KEY}" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
           },
           "@id": "contractdefinition-test-2",
           "accessPolicyId": "policy-test-2",
           "contractPolicyId": "policy-test-2",
           "assetsSelector": [
             {
              "@type": "CriterionDto",
              "edc:operandLeft": "https://w3id.org/edc/v0.0.1/ns/id",
              "edc:operator": "=",
              "edc:operandRight": "asset-test-1"
             }
           ]
         }' \
     -X POST http://localhost:11002/api/management/v2/contractdefinitions | jq
