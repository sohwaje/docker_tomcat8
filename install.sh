#!/bin/bash
# git clone https://github.com/sohwaje/docker_tomcat8.git
SCRIPT=$(readlink -f "$0")  # script Absolute path
BASEDIR=$(dirname "$SCRIPT") # script directory Absolute path
date_=$(date "+%Y%m%d%H%M%S")
IMAGE="tomcat8"           #도커 이미지
CONTAINER="tomcat8"       # 도커 컨테이너 이름
LOGDIR="/var/log/$CONTAINER"  # 호스트와 공유할 로그 디렉토리
Fport="18080"                 # Front Port
Bport="8080"                  # Backend Port 실제 컨테이너 포트
WEBHOOK_ADDRESS=""
## send slack func
function slack_message(){
    # $1 : message
    # $2 : true=good, false=danger

    COLOR="danger"
    icon_emoji=":scream:"
    if $2 ; then
        COLOR="good"
	icon_emoji=":smile:"
    fi
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *lab*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"' '"$icon_emoji"'"}]}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}
## send ok or not ok func
_retVal()
{
  local retVal=$?
  if [[ $retVal -eq 0 ]];then
    echo "[OK]"
    # do something
  else
    echo "[Failed]"
    exit 1
  fi
}
## send slack ok or not ok
_slackretVal()
{
  local retVal=$?
  if [[ $retVal -eq 0 ]];then
    slack_message "$CONTAINER Container has been created."
    # do something
  else
    slack_message "$CONTAINER Failed to create." false
    exit 1
  fi
}
### start
echo "[1] Docker install check"
echo "[Step 1/3 ---> Docker install check]"
  sudo docker -v >/dev/null 2>&1
  _retVal

echo "[2] Create Tomcat log directory"
if [[ ! -d $LOGDIR ]];then
  echo "[Step 2/3 ---> Create $LOGDIR]"
  sudo mkdir /var/log/$LOGDIR
else
  echo "[Step 2/3 ---> $LOGDIR log directory already exist. backup and create]"
  sudo mv $LOGDIR /var/log/$CONTAINER-$date_
  sudo mkdir $LOGDIR
fi

echo "[3] install tomcat8 docker"
echo "[Step 3/3 ---> docker build & run]"
docker build --pull=true -t $IMAGE $BASEDIR/ -q && \
  docker run -d -p $Fport:$Bport \
  --rm --name $CONTAINER \
  -v $LOGDIR:/usr/local/tomcat/logs \
  $IMAGE && echo "[ Successfully docker build and run $CONTAINER ]"

_slackretVal # check result
