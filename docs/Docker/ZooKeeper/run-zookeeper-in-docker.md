## Dockerfile

```dockerfile
FROM centos:7
MAINTAINER Peter Ericson <pdericson@gmail.com>

# https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && chmod +x /usr/local/bin/dumb-init

RUN yum install -y java-1.7.0-openjdk-headless tar

# https://www.apache.org/mirrors/dist.html
RUN curl -fL http://archive.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz | tar xzf - -C /opt && \
mv /opt/zookeeper-3.4.8 /opt/zookeeper

VOLUME /tmp/zookeeper

COPY entrypoint.sh /

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/zookeeper/bin

CMD ["zkServer.sh", "start-foreground"]
```

### entrypoint.sh

```bash
#!/bin/sh

echo "${MYID:-1}" > /tmp/zookeeper/myid

# based on https://github.com/apache/zookeeper/blob/trunk/conf/zoo_sample.cfg
cat > /opt/zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/tmp/zookeeper
clientPort=2181
EOF

# server.1=...
if [ -n "$SERVERS" ]; then
    printf '%s' "$SERVERS" | awk 'BEGIN { RS = "," }; { printf "server.%i=%s:2888:3888\n", NR, $0 }' >> /opt/zookeeper/conf/zoo.cfg
fi

exec "$@"
```


## Run Docker container

```bash
docker run -d \
    -e MYID=1 \
    -e SERVERS=node-1,node-2,node-3 \
    --name=zookeeper --net=host --restart=always mesoscloud/zookeeper:3.4.8-centos-7
```
