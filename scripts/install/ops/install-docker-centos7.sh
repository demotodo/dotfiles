#!/bin/bash

sudo yum -y update

#sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
#[dockerrepo]
#name=Docker Repository
#baseurl=https://yum.dockerproject.org/repo/main/centos/7/
#enabled=1
#gpgcheck=1
#gpgkey=https://yum.dockerproject.org/gpg
#EOF

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo


#sudo yum install -y docker-engine
sudo yum install -y docker-ce docker-ce-cli containerd.io


sudo systemctl enable docker.service
sudo systemctl start docker

# to verify
# sudo docker run --rm hello-world
