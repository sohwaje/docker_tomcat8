#!/bin/bash
# git clone https://github.com/sohwaje/docker_tomcat8.git
SCRIPT=$(readlink -f "$0")  # script Absolute path
BASEDIR=$(dirname "$SCRIPT") # script directory Absolute path
date_=$(date "+%Y%m%d%H%M%S")
IMAGE="tomcat8"
CONTAINER="tomcat8"
SOURCEDIR="/webapps"
LOGDIR="/var/log/$CONTAINER"

### start
echo "[1] Create Tomcat webapps directory"
if [[ -d $SOURCEDIR ]];then
  echo "[Step 1 ---> $SOURCEDIR log directory already exist. backup and create]"
  sudo mv $SOURCEDIR $SOURCEDIR-$date_
  sudo mkdir $SOURCEDIR
else
  echo "[Step 1 ---> $Create $SOURCEDIR]"
  sudo mkdir $SOURCEDIR
fi

echo "[2] Create Tomcat log directory"
if [[ -d $LOGDIR ]];then
  echo "[Step 2 ---> $LOGDIR log directory already exist. backup and create]"
  sudo mv $LOGDIR /var/log/$CONTAINER-$date_
  sudo mkdir $LOGDIR
else
  echo "[Step 2 ---> Create $LOGDIR]"
  sudo mkdir /var/log/$LOGDIR
fi

echo "[3] install tomcat8 docker"
echo "[Step 3 ---> docker build & run]"
docker build -t $IMAGE $BASEDIR/ && \
  docker run -d -p 18080:8080 \
  --name $CONTAINER \
  -v $SOURCEDIR:/usr/local/tomcat/webapps/ROOT \
  -v $LOGDIR:/usr/local/tomcat/logs \
  $IMAGE
