#!/bin/bash
# git clone https://github.com/sohwaje/docker_tomcat8.git
SCRIPT=$(readlink -f "$0")  # script Absolute path
BASEDIR=$(dirname "$SCRIPT") # script directory Absolute path
date_=$(date "+%Y%m%d%H%M%S")
IMAGE="tomcat8"
CONTAINER="tomcat8"
LOGDIR="/var/log/$CONTAINER"
Fport="18080"
Bport="8080"
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
### start
echo "[1] Docker install check"
echo "[Step 1 ---> Docker install check]"
  sudo docker -v >/dev/null 2>&1
  _retVal

echo "[2] Create Tomcat log directory"
if [[ ! -d $LOGDIR ]];then
  echo "[Step 2 ---> Create $LOGDIR]"
  sudo mkdir /var/log/$LOGDIR
else
  echo "[Step 2 ---> $LOGDIR log directory already exist. backup and create]"
  sudo mv $LOGDIR /var/log/$CONTAINER-$date_
  sudo mkdir $LOGDIR
fi

echo "[3] install tomcat8 docker"
echo "[Step 3 ---> docker build & run]"
docker build -tq $IMAGE $BASEDIR/ && \
  docker run -d -p $Fport:$Bport \
  --name $CONTAINER \
  -v $LOGDIR:/usr/local/tomcat/logs \
  $IMAGE && echo "[ Successfully docker build and run $CONTAINER ]"
