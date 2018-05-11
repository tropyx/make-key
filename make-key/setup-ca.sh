#!/bin/bash
mkdir -p ssldir/{conf,private,public,signed-keys}
cd ssldir
touch conf/index
echo 01 > conf/serial
echo "Don't forget to edit conf/openssl.conf"
