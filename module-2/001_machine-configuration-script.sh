#!/bin/bash

#install java8
sudo yum -y install java-1.8.0-openjdk-devel
sudo alternatives --config java
sudo alternatives --set javac /usr/lib/jvm/java-1.8.0-openjdk.x86_64/bin/javac

#install mvn
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

#test correct compilation
cd ~/environment/aws-modern-application-workshop/module-2/app/service
mvn install

#build docker image
echo 'call "aws sts get-caller-identity" command and write here UserId:'
read USERID
echo 'write region for user (something like "eu-west-1" or similar):'
read REGION

echo 'trying to build with docker tag: ' $USERID.dkr.ecr.$REGION.amazonaws.com/mythicalmysfits/service:latest
cd ~/environment/aws-modern-application-workshop/module-2/app
docker build . -t $USERID.dkr.ecr.$REGION.amazonaws.com/mythicalmysfits/service:latest

#asw repository creation
echo 'creating images repository...'
aws ecr create-repository --repository-name mythicalmysfits/service
#set login
$(aws ecr get-login --no-include-email)

echo 'pushing image into repository'
docker push $USERID.dkr.ecr.$REGION.amazonaws.com/mythicalmysfits/service

