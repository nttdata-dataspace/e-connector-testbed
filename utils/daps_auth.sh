#! /bin/bash
source .env || exit 1

token_url=${EDC_OAUTH_TOKEN_URL/host.docker.internal/localhost}
client_id=${EDC_OAUTH_CLIENT_ID}
# resource is later used as token audience, so it must be the IDS url of the token receiving connector
resource="https://receiving-connector/api/v1/ids/data"


base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

hmacsha256_sign()
{
  secret="foo"
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${secret}"
}

#audience="idsc:IDS_CONNECTORS_ALL"
audience=${EDC_OAUTH_PROVIDER_AUDIENCE}
header="{\"alg\": \"RS256\", \"typ\": \"JWT\"}"
payload="{\"iss\": \"${client_id}\",\"sub\":\"${client_id}\", \"exp\": 9999999999, \"iat\": 0, \"jti\": \"$(uuidgen)\", \"aud\": \"${audience}\"}"
echo ${payload}
header_base64=$(echo "${header}" | base64_encode)
payload_base64=$(echo "${payload}" | base64_encode)
header_payload=$(echo "${header_base64}.${payload_base64}")

pem=$( cat vault/key.pem )
signature=$( openssl dgst -sha256 -sign <(echo -n "${pem}") <(echo -n "${header_payload}") | openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )

jwt="${header_payload}"."${signature}"

grant_type="client_credentials"
client_assertion_type="urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
scope="idsc:IDS_CONNECTOR_ATTRIBUTES_ALL"

curl -s -X POST ${token_url} \
   -H "Content-Type: application/x-www-form-urlencoded" \
   -H "Accept: application/json" \
   -d "grant_type=${grant_type}&client_assertion_type=${client_assertion_type}&resource=${resource}&scope=${scope}&client_assertion=${jwt}" && echo
