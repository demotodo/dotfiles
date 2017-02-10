## etc



## startup script

```bash
sudo mkdir /var/lib/zookeeper
sudo vi /usr/lib/systemd/system/zookeeper.service

sudo systemctl enable zookeeper.service
sudo systemctl start zookeeper
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

or

```
[Unit]
Description=Apache ZooKeeper
After=network.target
ConditionPathExists=/etc/zookeeper/conf/zoo.cfg
ConditionPathExists=/etc/zookeeper/conf/log4j.properties

[Service]
Environment="ZOOCFGDIR=/etc/zookeeper/conf"
SyslogIdentifier=zookeeper
WorkingDirectory=/opt/zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start-foreground
Restart=on-failure
RestartSec=20
User=root
Group=root

[Install]
WantedBy=multi-user.target
```
