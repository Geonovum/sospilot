#!/bin/bash
# From: https://raw.githubusercontent.com/fgalan/oauth2-example-orion-client/master/token_script.sh
echo ""
read -p "Username: " USER
read -s -p "Password: " PASSWORD
echo ""

RESP=`curl -s -d "{\"username\": \"$USER\", \"password\":\"$PASSWORD\"}" -H "Content-type: application/json" https://orion.lab.fiware.org/token`

TOKEN=`echo $RESP`
echo -e "\nToken: $TOKEN"
echo ""
