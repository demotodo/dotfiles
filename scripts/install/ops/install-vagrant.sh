#!/bin/bash

# download the package first
sudo dpkg -i vagrant_1.8.1_x86_64.deb

# fix broken dependencies if any
sudo apt-get -f install
