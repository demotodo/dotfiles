## Use another JDK

1. setup logstash to be a service

2. edit `/etc/default/logstash`, to specify another JDK

```
JAVA_HOME=/opt/java/jdk-rc1.8.0_121/
```

3. edit `/etc/init.d/logstash`, to append new JDK to PATH

```
...
[ -r /etc/default/logstash ] && . /etc/default/logstash
[ -r /etc/sysconfig/logstash ] && . /etc/sysconfig/logstash

PATH=$JAVA_HOME/bin:$PATH
export PATH

[ -z "$nice" ] && nice=0
...
```
