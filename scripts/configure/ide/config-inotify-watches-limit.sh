#!/usr/bin/env bash

echo 'fs.inotify.max_user_watches = 524288' | sudo tee /etc/sysctl.d/idea.conf
sudo sysctl -p --system
