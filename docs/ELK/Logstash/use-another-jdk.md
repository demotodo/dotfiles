## No JDK installed

If no JDK installed, execute: 

```
yum install -y jdk-rc.x86_64
```


## Use another JDK (no JDK8 installed)

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

[ -z "$nice" ] && nice=0

PATH=$JAVA_HOME/bin:$PATH
export PATH

...
```

### script

```bash
mkdir -p /opt/java
cd /opt/java/
scp -oStrictHostKeyChecking=no root@fre01-p02-scs01:/opt/java/jdk-rc1.8.0_121.tar .
tar -xvf jdk-rc1.8.0_121.tar

echo "JAVA_HOME=/opt/java/jdk-rc1.8.0_121/" > /etc/default/logstash
sed -i -e 's#^trace\(\).*#PATH=$JAVA_HOME/bin:$PATH\nexport PATH\n\ntrace() {#' /etc/init.d/logstash

#service logstash start
#service logstash status
#ps -ef | grep logstash
```
