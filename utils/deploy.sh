#! /bin/bash

print_usage()
{
    echo "Usage: $0 <connector-name> [ -f <fqdn-of-connector> ] [ -p <participant-id> ] [ -k <keystore-password> ] [ -a <api-key> ] [ -o <output-dir> ]"
    echo "If <fqdn-of-connector> is not specified, the connector-name should be resolvable from other hosts by itself."
    echo "If <participant-id> is not specified, the connector-name is used as the participant ID."
}

if [ $#  -lt 1 ]; then
    print_usage
    exit 1
fi
MY_EDC_NAME=$1
shift

while getopts a:f:j:k:o:p: opt; do
    case $opt in
        a) EDC_API_AUTH_KEY=$OPTARG ;;
        f) MY_EDC_FQDN=$OPTARG ;;
        j) JAVA_KEYSTORE_FORMAT=$OPTARG ;;
        k) EDC_KEYSTORE_PASSWORD=$OPTARG ;;
        o) OUTDIR=$OPTARG ;;
        p) MY_PARTICIPANT_ID=$OPTARG ;;
        *) print_usage; exit 1 ;;
    esac
done

if [ -z ${MY_PARTICIPANT_ID} ]; then
    echo 'Participant ID is not specified; The connector name "'${MY_EDC_NAME}'" is used as the participant ID.'
    MY_PARTICIPANT_ID=${MY_EDC_NAME}
fi
if [ -z ${OUTDIR} ]; then
    echo "No output directory is specified; ./vault is assumed to be the output directory."
    OUTDIR=./vault
fi
mkdir -p ${OUTDIR} 2>/dev/null
if [ -z ${EDC_API_AUTH_KEY} ]; then
    eval $(grep EDC_API_AUTH_KEY ./connector/.env)
fi
if [ -z ${EDC_KEYSTORE_PASSWORD} ]; then
    eval $(grep EDC_KEYSTORE_PASSWORD ./connector/.env)
fi
if OPENSSL_PATH=$(type -p openssl); then
  if ${OPENSSL_PATH} version | grep -q "^OpenSSL 1"; then
    echo "OpenSSL v1.x is detected but not supported. Command execution aborted." 1>&2
    exit 1
  fi
else
  echo "OpenSSL executable not found. Command execution aborted." 1>&2
  exit 1
fi

read -p "The contents of the output directory will be overwritten. Do you wish to continue? " -n 1 -r
if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
    echo -e "\nAborted."
    exit 1
fi

if [ -f ${OUTDIR}/key.pem ] && [ -f ${OUTDIR}/cert.pem ]; then
  echo -e "\nA private key/certificate pair detected. The pair is preserved and a new keystore will be created."
else
  echo -e "\nGenerating a new key and certificate..."
  SUBJ_ARG="/C=JP/ST=Tokyo/L=Bunkyo-ku/O=Hongo/OU=International Testbed of Dataspace Technologies/CN=${MY_EDC_FQDN:-${MY_EDC_NAME}}"

  ${OPENSSL_PATH} req -x509 -newkey rsa:2048 -noenc -days 1000 -subj "${SUBJ_ARG}" \
        -keyout ${OUTDIR}/key.pem -out ${OUTDIR}/cert.pem
fi
${OPENSSL_PATH} pkcs12 -export -password pass:${EDC_KEYSTORE_PASSWORD} -name ${MY_EDC_NAME} \
        -inkey ${OUTDIR}/key.pem -in ${OUTDIR}/cert.pem \
        -out ${OUTDIR}/keystore.p12
mv -f ${OUTDIR}/keystore.jks{,-} 2>/dev/null
if [ ! -z ${JAVA_KEYSTORE_FORMAT} ] && [ ${JAVA_KEYSTORE_FORMAT} = "jks" ]; then
  keytool -noprompt -importkeystore \
          -srcstoretype pkcs12 -srckeystore ${OUTDIR}/keystore.p12 -srcstorepass ${EDC_KEYSTORE_PASSWORD} \
          -deststoretype jks -destkeystore ${OUTDIR}/keystore.jks -deststorepass ${EDC_KEYSTORE_PASSWORD}
else
  ln -s keystore.p12 ${OUTDIR}/keystore.jks
fi
EDC_OAUTH_CLIENT_ID=$(${OPENSSL_PATH} x509 -in ${OUTDIR}/cert.pem -text | sed -n -e '/Subject Key Identifier/{n;s/$/:keyid:/;p}' -e '/Authority Key Identifier/{n;p}' | tr -d ' \n')
echo ${MY_EDC_NAME}=$(sed ':a;N;$!ba;s/\n/\\n/g' ${OUTDIR}/cert.pem) > ${OUTDIR}/vault.properties

POSTGRES_UID=$(id -u)
POSTGRES_GID=$(id -g)
CONNECTOR_UID=${POSTGRES_UID}
CONNECTOR_GID=${POSTGRES_GID}
mkdir -p ./db/data ./db/home ./demo/data ./demo/home 2>/dev/null

echo -e "\nAdd the following lines to the .env file"
echo      "----------------------------------------"
for key in MY_EDC_NAME MY_PARTICIPANT_ID MY_EDC_FQDN EDC_KEYSTORE_PASSWORD EDC_API_AUTH_KEY EDC_OAUTH_CLIENT_ID CONNECTOR_UID CONNECTOR_GID POSTGRES_UID POSTGRES_GID; do
    var=$key
    if [ ! -z ${!var} ]; then
        echo $key=${!var}
    fi
done
exit 0
