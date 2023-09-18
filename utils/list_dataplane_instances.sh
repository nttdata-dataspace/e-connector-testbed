#! /bin/bash
source .env || exit 1

curl -s -H "X-Api-Key: ${EDC_API_AUTH_KEY}" -H "Content-Type: application/json" \
     -X GET http://localhost:11002/api/management/v2/dataplanes | jq
