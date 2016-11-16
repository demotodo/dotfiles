#!/usr/bin/env bash

sudo apt-get -y install unzip

curl -s "https://get.sdkman.io" | bash

# just need once
source "~/.sdkman/bin/sdkman-init.sh"

# check
sdk version
