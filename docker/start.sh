#!/bin/sh 

set -x
./eventsclient -server=$SERVER -channelID=$CHANNELID -filtered=$FILTERED -tls=$TLS -clientKey=$CLIENTKEY -clientCert=$CLIENTCERT -rootCert=$ROOTCERT
set +x
