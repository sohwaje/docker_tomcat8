#!/bin/bash
date_=$(date "+%Y%m%d%H%M%S")
NAME="docker_tomcat8"
URL="https://github.com/sohwaje/${NAME}.git"

### start
echo "Download tomcat8 Docker Source"
if [[ -d $NAME ]];then
  echo "[$NAME directory already exist. backup and Download]"
  mv $NAME $NAME-$date_
  git clone $URL
else
  echo "[$NAME directory does not exist. Download $URL]"
  git clone $URL
fi

echo "install tomcat8 docker"
docker build -t tomcat8 -f ~/$NAME
