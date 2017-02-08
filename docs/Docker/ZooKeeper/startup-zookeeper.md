## etc



## startup script

```bash
sudo mkdir /var/lib/zookeeper
sudo vi /usr/lib/systemd/system/zookeeper.service
```

```
[Unit]
Description=Apache Zookeeper server 
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target 
After=network.target remote-fs.target

[Service]
Type=forking
Restart=always
RestartSec=20
ExecStart=/opt/zookeeper/bin/zkServer.sh start
ExecStop=/opt/zookeeper/bin/zkServer.sh stop
ExecReload=/opt/zookeeper/bin/zkServer.sh restart
WorkingDirectory=/var/lib/zookeeper

[Install]
WantedBy=multi-user.target
```
