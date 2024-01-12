#! /bin/bash
source .env || exit 1

curl -s -H "X-Api-Key: ${EDC_API_AUTH_KEY}" -H "Content-Type: application/json" \
     -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
           },
           "@type": "Asset",
           "@id": "asset-test-1",
           "properties": {
             "name": "product description",
             "contentType": "application/json"
           },
           "privateProperties": {
           },
           "dataAddress": {
             "@type": "DataAddress",
             "type": "HttpData",
             "name": "Test asset",
             "baseUrl": "http://backend/test.txt",
             "proxyPath": "true"
           }
         }' \
     -X POST http://localhost:11002/api/management/v3/assets | jq
