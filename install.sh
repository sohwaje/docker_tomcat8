#!/bin/bash
date_=$(date "+%Y%m%d%H%M%S")
BASEDIR="docker_tomcat8"
URL="https://github.com/sohwaje/${BASEDIR}.git"
IMAGE="tomcat8"
CONTAINER="tomcat8"
SOURCEDIR="/webapps"
SOURCE="webapps/sample.war"
LOGDIR="/var/log/$CONTAINER"

### start
echo "[1] Download tomcat8 Docker Source"
if [[ -d $BASEDIR ]];then
  echo "[Step ---> $BASEDIR directory already exist. backup and Download]"
  mv $BASEDIR $BASEDIR-$date_
  git clone $URL
else
  echo "[Step ---> Download $URL]"
  git clone $URL
fi

echo "[2] Create Tomcat webapps directory"
if [[ -d $SOURCEDIR ]];then
  echo "[Step ---> $SOURCEDIR log directory already exist. backup and create]"
  sudo mv $SOURCEDIR $SOURCEDIR-$date_
  sudo mkdir $SOURCEDIR
else
  echo "[Step ---> $Create $SOURCEDIR]"
  sudo mkdir $SOURCEDIR
fi

echo "[3] Copy source file to $SOURCEDIR"
if [[ -f $(ls $SOURCEDIR) ]] && [[ -r $(ls $SOURCEDIR) ]];then
  echo "[Step ---> $SOURCE file already exist. backup and copy]"
  cd $BASEDIR
  sudo cp -arv $SOURCE $SOURCEDIR
else
  echo "[Step ---> $SOURCE file copy]"
  cd $BASEDIR
  sudo cp -arv $SOURCE $SOURCEDIR
fi

echo "[4] Create Tomcat log directory"
if [[ -d $LOGDIR ]];then
  echo "[Step ---> $LOGDIR log directory already exist. backup and create]"
  sudo mv $LOGDIR /var/log/$CONTAINER-$date_
  sudo mkdir $LOGDIR
else
  echo "[Step ---> Create $LOGDIR]"
  sudo mkdir /var/log/$LOGDIR
fi

echo "[5] install tomcat8 docker"
docker build -t $IMAGE ~/$BASEDIR && \
  docker run -d -p 18080:8080 \
  --name $CONTAINER \
  -v $SOURCEDIR:/usr/local/tomcat8/webapps/ROOT \
  -v $LOGDIR:/usr/local/tomcat8/logs \
  $IMAGE
