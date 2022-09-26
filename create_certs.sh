#!/bin/bash

function log() {
echo "$1" >&2
}

function die() {
log "$1"
exit 1
}

function check_exist() {
[ ! -z "$(command -v openssl)" ] || die "The the 'openssl' command is missing - Please install"
[ ! -z "$(command -v docker)" ] || die "The the 'docker' command is missing - Please install"
[ ! -z "$(command -v docker-compose)" ] || die "The the 'docker-compose' command is missing - Please install"
}

check_exist


set -o nounset \
    -o errexit
PASS="password"
printf "Deleting previous (if any)..."
mkdir -p secrets
mkdir -p tmp
mkdir -p ca
echo " OK!"

CA_CERT=ca/elk-ca.crt
CA_KEY=ca/elk-ca.key

printf "Creating ELK CA..."
if [[ ! -f $CA_CERT ]] && [[ ! -f $CA_KEY ]];then
openssl req -new -x509 -keyout $CA_KEY -out $CA_CERT -days 3650 -subj '/CN=ELK CA/OU=Devops/O=Devopsforall/L=Hyderabad/C=IN' -passin pass:$PASS -passout pass:$PASS >/dev/null 2>&1
echo " OK"
else
printf "CA certs already exists - Skip creating it.."
echo " OK!"
fi

for i in 'elastic1' 'elastic2' 'elastic3' 'kibana' 'filebeat' 'logstash' 'client'
do
 if [[ ! -f secrets/$i.key ]] && [[ ! -f secrets/$i.crt ]];then
 printf "Creating cert and key of $i..."
 openssl req -subj "/C=IN/ST=TG/L=Hyderabad/O=Devopsforall/OU=IT Department/CN=$i"  -new -sha256 -nodes -out tmp/$i.csr -newkey rsa:2048 -keyout secrets/$i.key  >/dev/null 2>&1
 openssl x509 -req -passin pass:$PASS -in tmp/$i.csr -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out secrets/$i.crt -days 500 -sha256 -extfile  <(printf "subjectAltName=DNS:localhost,DNS:$i")  >/dev/null 2>&1
echo " OK!"
else
  printf "Cert $i.crt and Key $i.key already exist..skip creating it.."
  echo " OK!"
fi
done

rm -rf tmp

echo "SUCCEEDED"
