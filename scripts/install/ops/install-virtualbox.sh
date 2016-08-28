#!/bin/bash

# download the package first
sudo dpkg -i virtualbox-5.0_5.0.26-108824-Ubuntu-trusty_amd64.deb

# fix broken dependencies if any
sudo apt-get -f install
