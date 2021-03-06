#!/bin/sh

echo "elhostname: $1"
echo "eldomain: $2"
CN="${S1=`hostname`}.${eldomain=org}"
echo $CN

mkdir -p keys

# Generate self signed root CA cert
# the CN of the CA must to be different thant server certificate
openssl req -nodes -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -subj "/C=US/CN=Example-Root-CA"


# Generate server cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/CN=`hostname`"

# Sign the server cert
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

# Create server PEM file
cat server.key server.crt > server.pem


# Generate client cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout client.key -out client.csr -subj "/CN=`hostname` "

# Sign the client cert
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAserial ca.srl -out client.crt

# Create client PEM file
cat client.key client.crt > client.pem

mv ca.* keys
mv client.* keys
mv server.* keys

