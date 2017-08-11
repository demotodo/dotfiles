#!/bin/bash

curl -LO http://downloads.sourceforge.net/sshpass/sshpass-1.06.tar.gz
md5sum sshpass-1.06.tar.gz      #f59695e3b9761fb51be7d795819421f9

tar xvf sshpass-1.06.tar.gz
cd sshpass-1.06

./configure
make
sudo make install
