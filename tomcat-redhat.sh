#!/bin/bash

# Installing necessary packages
sudo yum update -y 
sudo yum install -y java wget git

# Downloading Apache Tomcat 9.0.68 version to OPT folder
cd /opt
sudo systemctl stop tomcat
sudo rm -rf apache* tomcat*
sudo mkdir -p /opt/tomcat
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68.tar.gz
sudo tar xf apache-tomcat-9.0.68.tar.gz -C /opt/tomcat
sudo rm -rf apache-tomcat-9.0.68.tar.gz

# Configuring Tomcat server for manager, host-manager and tomcat users
sudo git clone https://github.com/artisantek/tomcat-redhat.git
sudo cp tomcat-redhat/context.xml /opt/tomcat/apache-tomcat-9.0.68/webapps/manager/META-INF/context.xml
sudo cp tomcat-redhat/context.xml /opt/tomcat/apache-tomcat-9.0.68/webapps/host-manager/META-INF/context.xml
sudo cp tomcat-redhat/tomcat-users.xml /opt/tomcat/apache-tomcat-9.0.68/conf/tomcat-users.xml

# Configuring Tomcat as a Service
sudo useradd -r -M -U -d /opt/tomcat -s /bin/false tomcat
sudo chown -R tomcat: /opt/tomcat/*
sudo cp tomcat-redhat/tomcat.service /etc/systemd/system/tomcat.service
sudo rm -rf tomcat-redhat
sudo systemctl daemon-reload
sudo systemctl start tomcat

# Check if tomcat is working
sudo systemctl is-active --quiet tomcat
echo "\n################################################################ \n"
if [ $? -eq 0 ]; then
	echo "Tomcat installed Successfully"
	echo "Access Tomcat using $(curl -s ifconfig.me):8080"
else
	echo "Tomcat installation failed"
fi
