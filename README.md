## 사전 준비 사항
### 우분투
<pre><code>
apt install g++
cd $HOME
curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0

$HOME/.profile 에 다음 추가
PATH=$PATH:$HOME/fabric-samples/bin
</code></pre>

### 아티팩트 생성
<pre><code>
export FABRIC_CFG_PATH=$PWD
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=marketcc  && configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Store1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Store1MSP

configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Store2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Store2MSP
</code></pre>

### 네트워크 실행
<pre><code>
docker-compose up -d
</code></pre>

### 채널 생성
<pre><code>
docker exec -it cli bash
</code></pre>

<pre><code>
./script/script.sh omarketcc 10 60
</code></pre>

### 클라이언트 어플리케이션 위치
* Open market header : omarket/app/main
* Store1             : omarket/app/store1
* Store2             : omarket/app/store2

### 클라이언트 어플리케이션은 각 경로에서 실행
<pre><code>
node app.js
</code></pre>

### 이벤트 핸들러 
#### 이벤트 핸들러 컴파일
<pre><code>
go get github.com/hyperledger/fabric
cd $GOPATH/src/github.com/hyperledger/fabric/examples/events/eventsclient
go build
</code></pre>

#### 이벤트 핸들러 컨테이너 생성
<pre><code>
cp eventsclient omarket프로젝트경로/docker
cd omarket프로젝트경로/docker
docker build -t eventsclient .
</code></pre>
