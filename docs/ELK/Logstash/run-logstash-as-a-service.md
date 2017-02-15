## Start as a service (CentOS)

1. modify options in `/etc/logstash/startup.options` if needed
```
LS_USER=root
LS_GROUP=root
```

2. execute following command to register service entry (CentOS 6 - `sysv`/`upstart` or  CentOS 7 - `systemd`) 
```
/usr/share/logstash/bin/system-install /etc/logstash/startup.options sysv
```

3. execute following command 
```
chkconfig --add logstash
chkconfig --list | grep logstash
```

4. start the service
```
service logstash start
```

### script

**CentOS 6**

```bash
sed -i -e 's#-Xmx1g#-Xmx512m#' /etc/logstash/jvm.options
sed -i -e 's#LS_USER=.*#LS_USER=root#' -e 's#LS_GROUP=.*#LS_GROUP=root#' /etc/logstash/startup.options

rm -f /etc/init/logstash.conf

## CentOS 6
/usr/share/logstash/bin/system-install /etc/logstash/startup.options sysv
chkconfig --add logstash
chkconfig --list | grep logstash

## to add customized logstash conf files

#service logstash start
#service logstash status
#ps -ef | grep logstash
```

**CentOS 7**

```bash
sed -i -e 's#-Xmx1g#-Xmx512m#' /etc/logstash/jvm.options
sed -i -e 's#LS_USER=.*#LS_USER=root#' -e 's#LS_GROUP=.*#LS_GROUP=root#' /etc/logstash/startup.options

rm -f /etc/init/logstash.conf

## CentOS 7
/usr/share/logstash/bin/system-install /etc/logstash/startup.options systemd
systemctl enable logstash

## to add customized logstash conf files

#systemctl start logstash
```

### bg job

```
/usr/share/logstash/bin/logstash --path.settings /etc/logstash
nohup /usr/share/logstash/bin/logstash --path.settings /etc/logstash &
```


## Start as a service (Windows)

Use NSSM to install a new service.

Run Command Prompt as administrator, and execute following commands:
```
nssm install Logstash C:\Tools\logstash-5.1.2\bin\logstash.bat
nssm set Logstash AppDirectory C:\Tools\logstash-5.1.2\bin
nssm set Logstash AppParameters -f C:\Tools\logstash-5.1.2\conf.d\logstash-jws.conf
nssm set Logstash DisplayName Logstash (jws)
nssm set Logstash Start SERVICE_AUTO_START
nssm set Logstash AppStdout C:\Tools\logstash-5.1.2\logs\logstash-stdout.log
nssm set Logstash AppStderr C:\Tools\logstash-5.1.2\logs\logstash-stderr.log
nssm set Logstash AppRotateFiles 1
nssm set Logstash AppRotateOnline 1
nssm set Logstash AppRotateSeconds 0
nssm set Logstash AppRotateBytes 50000000
```
