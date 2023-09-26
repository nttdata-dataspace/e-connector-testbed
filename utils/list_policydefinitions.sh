#! /bin/bash
source .env || exit 1

curl -s -H "X-Api-Key: ${EDC_API_AUTH_KEY}" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
            },
            "@type": "QuerySpecDto",
            "offset": 0,
            "limit": 100
         }' \
     -X POST http://localhost:11002/api/management/v2/policydefinitions/request | jq
