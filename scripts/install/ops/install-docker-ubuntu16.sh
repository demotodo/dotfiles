#!/bin/bash

# refer to: https://docs.docker.com/engine/installation/linux/ubuntulinux/

#sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get -y update

# recommended
#sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

#sudo apt-get -y install docker-engine
sudo apt-get -y install docker-ce

#sudo service docker start
#sudo docker run hello-world
