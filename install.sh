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
echo "[2] Create Tomcat webapps directory"
if [[ -d $SOURCEDIR ]];then
  echo "[Step 3 ---> $SOURCEDIR log directory already exist. backup and create]"
  sudo mv $SOURCEDIR $SOURCEDIR-$date_
  sudo mkdir $SOURCEDIR
else
  echo "[Step 3 ---> $Create $SOURCEDIR]"
  sudo mkdir $SOURCEDIR
fi

echo "[3] Create Tomcat log directory"
if [[ -d $LOGDIR ]];then
  echo "[Step 4 ---> $LOGDIR log directory already exist. backup and create]"
  sudo mv $LOGDIR /var/log/$CONTAINER-$date_
  sudo mkdir $LOGDIR
else
  echo "[Step 4 ---> Create $LOGDIR]"
  sudo mkdir /var/log/$LOGDIR
fi

echo "[4] install tomcat8 docker"
docker build -t $IMAGE $BASEDIR/ && \
  docker run -d -p 18080:8080 \
  --name $CONTAINER \
  -v $SOURCEDIR:/usr/local/tomcat8/webapps/ROOT \
  -v $LOGDIR:/usr/local/tomcat8/logs \
  $IMAGE
