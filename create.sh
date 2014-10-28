#!/bin/bash

DAYS=3650

# example: http://svn.red-bean.com/repos/main/3bits/servercert_3bits.txt

# 1 Create a Certifying Authority (CA) keypair.
#   ca.crt / ca.key

#   a. generate key

        openssl genrsa -out ca.key 1024

#   b. create CA cert, valid for the next 3650 days
#      all questions can be leave blank.

        openssl req -new -key ca.key -x509 -days $DAYS -out ca.crt

# 2 Create CA-Signed Server Cert
#   a. generate key for the server itself

        openssl genrsa -out server.key

#   b. create CSR for server.key

        openssl req -new -key server.key -out server.csr
#
#       [answer questions...]
#       Common Name: <-- this MUST be full qualified domain name.

#   c. have the CA sign the CSR

        openssl x509 -req -days $DAYS -in server.csr -CA ca.crt \
            -CAkey ca.key -CAcreateserial -out server.crt

# Optional, create client.pem for client side use
        
        cat server.crt server.key > client.pem


