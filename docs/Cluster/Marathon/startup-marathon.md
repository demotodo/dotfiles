## etc



## startup script

Script file `/usr/lib/systemd/system/marathon.service`:
```
[Unit]
Description=Marathon
After=network.target
Wants=network.target

[Service]
EnvironmentFile=-/etc/sysconfig/marathon
ExecStart=/usr/bin/marathon
Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target
```
