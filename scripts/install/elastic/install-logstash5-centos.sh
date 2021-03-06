#!/usr/bin/env bash

sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat << EOF | sudo tee /etc/yum.repos.d/logstash.repo
[logstash-5.x]
name=Elastic repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo yum install -y logstash


## install plugins
# /usr/share/logstash/bin/logstash-plugin install logstash-filter-aggregate
