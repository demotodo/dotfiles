#!/bin/bash

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip

sudo ./aws/install

which aws
aws --version


# shell completion
which aws_completer
complete -C '/usr/local/bin/aws_completer' aws
