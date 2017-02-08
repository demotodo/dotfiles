## Dockfile

```dockerfile
FROM centos:7
MAINTAINER Peter Ericson <pdericson@gmail.com>

# https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && chmod +x /usr/local/bin/dumb-init

RUN rpm -i http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
yum -y install marathon-1.1.1 mesos-0.28.1

CMD ["marathon", "--no-logger"]

COPY entrypoint.sh /

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]
```

### entrypoint.sh

```bash
#!/bin/sh

PRINCIPAL=${PRINCIPAL:-root}

if [ -n "$SECRET" ]; then
    export MARATHON_MESOS_AUTHENTICATION_PRINCIPAL=${MARATHON_MESOS_AUTHENTICATION_PRINCIPAL:-$PRINCIPAL}
    touch /tmp/secret
    chmod 600 /tmp/secret
    printf '%s' "$SECRET" > /tmp/secret
    export MARATHON_MESOS_AUTHENTICATION_SECRET_FILE=/tmp/secret
fi

exec "$@"
```


## Run Docker container

```bash
docker run -d \
    -e MARATHON_HOSTNAME=ip.address \
    -e MARATHON_HTTPS_ADDRESS=ip.address \
    -e MARATHON_HTTP_ADDRESS=ip.address \
    -e MARATHON_MASTER=zk://node-1:2181,node-2:2181,node-3:2181/mesos \
    -e MARATHON_ZK=zk://node-1:2181,node-2:2181,node-3:2181/marathon \
    --name marathon --net host --restart always mesoscloud/marathon:1.1.1-centos-7
```
