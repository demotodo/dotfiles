#!/bin/bash

cp /etc/rc.local /etc/rc.local.bak

sed -i /^exit/d /etc/rc.local

echo "echo 358 > /sys/class/backlight/intel_backlight/brightness" >> /etc/rc.local
echo "" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
