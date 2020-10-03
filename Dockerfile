FROM tomcat:8.5-jre8

MAINTAINER Sohwaje <sohwaje@gmail.com>

# GC log directory
RUN mkdir /usr/local/tomcat/logs/gclog

# 환경 설정 파일 복사
ADD conf/setenv.sh /usr/local/tomcat/bin
RUN chmod +x /usr/local/tomcat/bin/setenv.sh

# tomcat 설정 파일 복사
ADD conf/server.xml /usr/local/tomcat/conf

# tomcat-user.xml. ROOT.xml(DB설정, 소스 설정) 파일 복사
ADD conf/ROOT.xml /usr/local/tomcat/conf/Catalina/localhost
ADD conf/tomcat-users.xml /usr/local/tomcat/conf

# 필요한 라이브러리 복사
ADD lib/mysql-connector-java-8.0.21.jar /usr/local/tomcat/lib
ADD lib/tomcat-extensions.jar /usr/local/tomcat/lib

# 소스 war 파일 복사
RUN rm -rf /usr/local/tomcat/webapps/ROOT
ADD webapps/sample.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]
