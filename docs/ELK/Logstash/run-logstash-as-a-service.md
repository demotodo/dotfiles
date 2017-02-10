## Start as a service (CentOS)

1. modify options in `/etc/logstash/startup.options` of needed

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
    service start logstash
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
