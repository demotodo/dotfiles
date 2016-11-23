#!/bin/bash

# refer to: https://docs.docker.com/engine/installation/linux/ubuntulinux/

#sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# for ubuntu 14.04 LTS
echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' | sudo tee /etc/apt/sources.list.d/docker.list

# remove old repo
sudo apt-get -y purge lxc-docker

sudo apt-get -y update

# recommended
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo apt-get -y install docker-engine

#sudo service docker start
#sudo docker run hello-world
