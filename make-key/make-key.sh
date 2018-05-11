#!/bin/sh

# Make a certificate/private key pair using a locally generated
# root certificate.
# Adapted by Mike Lindner from the OpenVPN Easy-RSA script
# for Build Your Own Secure Personal Cloud
# www.leanpub.com/cloudbook
# Change the country variable /C to suit yours.

if test $# -lt 1; then
        echo "usage: make-key <client-name> [<server-name>]";
        exit 1
fi

mkdir $1
openssl req -days 3650 \
-nodes -new -keyout $1/$1.key \
-out $1/$1.csr \
-config conf/openssl.cnf \
-subj "/C=AU/CN=$1"  && \

openssl ca -days 3650 \
-out $1/$1.crt -in $1/$1.csr \
-config conf/openssl.cnf \
-subj "/C=AU/CN=$1"&& \
chmod 0600 $1/$1.key

cp public/root.pem $1/ca.crt

if test $# -eq 2; then

CLIENT="
client
\ndev tun
\nproto udp
\nremote $2 1194
\nresolv-retry infinite
\nnobind
\npersist-key
\npersist-tun
\nca   /etc/openvpn/ca.crt
\ncert /etc/openvpn/$1.crt
\nkey  /etc/openvpn/$1.key
\ncomp-lzo
\nverb 4    #logging verbosity"

echo $CLIENT > $1/client.conf

fi
