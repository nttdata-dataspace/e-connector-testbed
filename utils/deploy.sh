#! /bin/bash

print_usage()
{
    echo "Usage: $0 <connector-name> [ -f <fqdn-of-connector> ] [ -p <keystore-password> ] [ -a <api-key> ] [ -o <output-dir> ]"
    echo "If <fqdn-of-connector> is not specified, the connector-name should be resolvable from other hosts by itself."
}

if [ $#  -lt 1 ]; then
    print_usage
    exit 1
fi
MY_EDC_NAME=$1
shift

while getopts a:f:o:p: opt; do
    case $opt in
	a) EDC_API_AUTH_KEY=$OPTARG ;;
	f) MY_EDC_FQDN=$OPTARG ;;
	o) OUTDIR=$OPTARG ;;
	p) EDC_KEYSTORE_PASSWORD=$OPTARG ;;
	*) print_usage; exit 1 ;;
    esac
done

if [ -z ${OUTDIR} ]; then
    echo "No output directory is specified; ./vault is assumed to be the output directory."
    OUTDIR=./vault
fi
if [ -z ${EDC_API_AUTH_KEY} ]; then
    eval $(grep EDC_API_AUTH_KEY ./connector/.env)
fi
if [ -z ${EDC_KEYSTORE_PASSWORD} ]; then
    eval $(grep EDC_KEYSTORE_PASSWORD ./connector/.env)
fi

read -p "The contents of the output directory will be overwritten. Do you wish to continue? " -n 1 -r
if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
    echo -e "\nAborted."
    exit 1
fi

echo -e "\nGenerating a new key and certificate..."
SUBJ_ARG="/C=JP/ST=Tokyo/L=Bunkyo-ku/O=Hongo/OU=International Testbed for Dataspace Technology/CN=${MY_EDC_NAME}"

openssl req -x509 -newkey rsa:2048 -noenc -days 1000 -subj "${SUBJ_ARG}" \
	-keyout ${OUTDIR}/key.pem -out ${OUTDIR}/cert.pem
openssl pkcs12 -export -password pass:${EDC_KEYSTORE_PASSWORD} -name ${MY_EDC_NAME} \
	-inkey ${OUTDIR}/key.pem -in ${OUTDIR}/cert.pem \
	-out ${OUTDIR}/keystore.p12
mv -f ${OUTDIR}/keystore.jks{,-} 2>/dev/null
keytool -noprompt -importkeystore \
	-srcstoretype pkcs12 -srckeystore ${OUTDIR}/keystore.p12 -srcstorepass ${EDC_KEYSTORE_PASSWORD} \
	-deststoretype jks -destkeystore ${OUTDIR}/keystore.jks -deststorepass ${EDC_KEYSTORE_PASSWORD}
EDC_OAUTH_CLIENT_ID=$(openssl x509 -in ${OUTDIR}/cert.pem -text | sed -n -e '/Subject Key Identifier/{n;s/$/:keyid:/;p}' -e '/Authority Key Identifier/{n;p}' | tr -d ' \n')
echo ${MY_EDC_NAME}=$(sed ':a;N;$!ba;s/\n/\\n/g' ${OUTDIR}/cert.pem) > ${OUTDIR}/vault.properties

echo -e "\nAdd the following lines to the .env file"
echo      "----------------------------------------"
for key in MY_EDC_NAME MY_EDC_FQDN EDC_KEYSTORE_PASSWORD EDC_API_AUTH_KEY EDC_OAUTH_CLIENT_ID; do
    var=$key
    if [ ! -z ${!var} ]; then
	echo $key=${!var}
    fi
done
exit 0
