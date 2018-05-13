FROM hyperledger/fabric-baseimage:x86_64-0.4.6

RUN mkdir -p /opt/gopath/src/github.com/hyperledger
WORKDIR /opt/gopath/src/github.com/hyperledger
RUN git clone https://github.com/hyperledger/fabric.git

COPY eventsclient /root/eventsclient
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

WORKDIR /root

CMD ./start.sh

#CMD ./eventsclient -server=$SERVER -channelID=$CHANNELID -filtered=$FILTERED -tls=$TLS -clientKey=$CLIENTKEY -clientCert=$CLIENTCERT -rootCert=$ROOTCERT
