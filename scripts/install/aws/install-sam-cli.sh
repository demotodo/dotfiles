#!/bin/bash

cd /tmp
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation

sudo ./sam-installation/install
#sudo ./sam-installation/install --update

which sam
sam --version


# shell completion
sudo wget https://raw.githubusercontent.com/daisuke-awaji/sam_completion/master/sam_completion -P /etc/bash_completion.d/

## if 'bash_completion' is already installed, do not need followings

#echo "source /etc/bash_completion.d/sam_completion" >> ~/.bashrc
#source ~/.bashrc
