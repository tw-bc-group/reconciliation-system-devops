#!/usr/bin/env bash

http_port=$1

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt-get update

sudo apt install default-jre -y
sudo apt-get install jenkins -y

# Change the http port that Jenkins use, default is 8080.
sudo sed -i "s/HTTP_PORT=8080/HTTP_PORT=${http_port}/g" /etc/default/jenkins

sudo systemctl restart jenkins.service

# The Docker Registry 2.0 implementation for storing and distributing Docker images
docker run -d -p 5000:5000 --name registry registry:2