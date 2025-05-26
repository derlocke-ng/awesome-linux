#! /bin/bash
# GNU General Public License v3.0
# This script is licensed under the GNU GPL v3.0. See LICENSE file for details.

### Usage
## create new CA
# ./ksslgen.sh new_ca
## create new self-signed wildcard ssl cert
# ./ksslgen.sh new_cert example.com

# Function to create a new kiwiCA
new_ca() {
  openssl genrsa -des3 -out kiwiCA.key 4096
  openssl req -x509 -new -nodes -key kiwiCA.key -sha256 -days 3650 -out kiwiCA.pem -subj "/C=NZ/ST=kiwi/L=kiwi/O=kiwi/OU=kiwi/CN=kiwiCA"
}

# Function to use an kiwiCA and create new certificates
new_cert() {
  local DOMAIN="$2"
  openssl genrsa -out "${DOMAIN}.key" 4096
  openssl req -new -key "${DOMAIN}.key" -out "${DOMAIN}.csr" -subj "/C=NZ/ST=kiwi/L=kiwi/O=kiwi/OU=kiwi/CN=${DOMAIN}"
  cat > openssl.cnf << EOL
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}
DNS.2 = *.${DOMAIN}
EOL
  openssl x509 -req -in "${DOMAIN}.csr" -CA kiwiCA.pem -CAkey kiwiCA.key -CAcreateserial -out "${DOMAIN}.pem" -days 3650 -sha256 -extfile openssl.cnf
  rm -f openssl.cnf
}

case $1 in
  new_ca|new_cert) "$1" "$@" ;;
esac
