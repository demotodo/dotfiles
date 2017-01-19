#!/bin/bash

sudo yum -y update

sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

sudo yum install -y docker-engine

sudo systemctl enable docker.service
sudo systemctl start docker

# to verify
# sudo docker run --rm hello-world
