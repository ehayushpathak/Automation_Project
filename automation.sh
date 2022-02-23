#!/bin/bash

s3bucket="upgrad-ehayushpathak/logs"
name="ayush"
timestamp=$(date '+%d%m%Y-%H%M%S')

sudo apt update -y

#Install Apache2
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; then
	apt install apache2 -y
fi

#Install AWS CLI
sudo apt-get install awscli -y

#Check if apache is running

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
        echo "Apache2 is running"
else
        sudo service apache2 start
        echo "apache2 started"

fi

#Check if apache is enabled
if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
        echo "Apache2 is enabled"
else
                sudo systemctl enable apache2
        echo "Apache2 enabled"
fi

#Backing up logs into /tmp

cd /var/log/apache2/
tar -cvf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

#Copying logs to S3 bucket

aws s3 \
cp /tmp/${name}-httpd-logs-${timestamp}.tar \
s3://${s3bucket}/${name}-httpd-logs-${timestamp}.tar