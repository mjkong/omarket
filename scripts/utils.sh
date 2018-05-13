#!/bin/sh


verifyResult () {
        if [ $1 -ne 0 ] ; then
                echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute End-2-End Scenario ==========="
                echo
                exit 1
        fi
}

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
        CORE_PEER_LOCALMSPID="MjmallMSP"
        CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/omarket.com/orderers/orderer.omarket.com/msp/tlscacerts/tlsca.omarket.com-cert.pem
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/omarket.com/users/Admin@omarket.com/msp
}

setGlobals () {
        PEER=$1
        ORG=$2
        if [ $ORG -eq 1 ] ; then
                CORE_PEER_LOCALMSPID="Store1MSP"
                CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/store1.omarket.com/peers/peer0.store1.omarket.com/tls/ca.crt
                CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/store1.omarket.com/users/Admin@store1.omarket.com/msp
                if [ $PEER -eq 0 ]; then
                        CORE_PEER_ADDRESS=peer0.store1.omarket.com:7051
                else
                        CORE_PEER_ADDRESS=peer1.store1.omarket.com:7051
                fi
        elif [ $ORG -eq 2 ] ; then
                CORE_PEER_LOCALMSPID="Store2MSP"
                CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/store2.omarket.com/peers/peer0.store2.omarket.com/tls/ca.crt
                CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/store2.omarket.com/users/Admin@store2.omarket.com/msp
                if [ $PEER -eq 0 ]; then
                        CORE_PEER_ADDRESS=peer0.store2.omarket.com:7051
                else
                        CORE_PEER_ADDRESS=peer1.store2.omarket.com:7051
                fi

        elif [ $ORG -eq 3 ] ; then
                CORE_PEER_LOCALMSPID="Store3MSP"
                CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/store3.omarket.com/peers/peer0.store3.omarket.com/tls/ca.crt
                CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/store3.omarket.com/users/Admin@store3.omarket.com/msp
                if [ $PEER -eq 0 ]; then
                        CORE_PEER_ADDRESS=peer0.store3.omarket.com:7051
                else
                        CORE_PEER_ADDRESS=peer1.store3.omarket.com:7051
                fi
        else
                echo "================== ERROR !!! ORG Unknown =================="
        fi

        env |grep CORE
}

joinChannelWithRetry () {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

        set -x
  peer channel join -b $CHANNEL_NAME.block  &> log.txt
  res=$?
        set +x
  cat log.txt
  if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
    COUNTER=` expr $COUNTER + 1`
    echo "peer${PEER}.org${ORG} failed to join the channel, Retry after $DELAY seconds"
    sleep $DELAY
    joinChannelWithRetry $PEER $ORG
  else
    COUNTER=1
  fi
  verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to Join the Channel"
}

installChaincode () {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG
  VERSION=${3:-1.0}
        set -x
  peer chaincode install -n mycc -v ${VERSION} -l ${LANGUAGE} -p ${CC_SRC_PATH} &> log.txt
  res=$?
        set +x
  cat log.txt
  verifyResult $res "Chaincode installation on peer${PEER}.org${ORG} has Failed"
  echo "===================== Chaincode is installed on peer${PEER}.org${ORG} ===================== "
  echo
}
