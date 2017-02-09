## Dockerfile

```dockerfile
FROM centos:7
MAINTAINER Peter Ericson <pdericson@gmail.com>

# https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && chmod +x /usr/local/bin/dumb-init

RUN rpm -i http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
yum -y install chronos-2.4.0 mesos-0.24.1

COPY entrypoint.sh /

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]
```

### entrypoint.sh

```bash
#!/bin/sh

CMD="chronos run_jar"

# Parse environment variables
for env in $(set | grep ^CHRONOS_ | cut -d= -f1); do
    opt=$(echo "$env" | cut -d_ -f2- | tr '[:upper:]' '[:lower:]')
    arg=""; eval arg=\$"$env"
    CMD="$CMD --$opt $arg"
done

# authentication
PRINCIPAL=${PRINCIPAL:-root}

if [ -n "$SECRET" ]; then
    touch /tmp/secret
    chmod 600 /tmp/secret
    printf "%s" "$SECRET" > /tmp/secret
    CMD="$CMD --mesos_authentication_principal $PRINCIPAL --mesos_authentication_secret_file /tmp/secret"
fi

echo "$CMD"

if [ $# -gt 0 ]; then
    exec "$@"
fi

eval "exec $CMD"
```


## Run Docker container

```bash
docker run -d \
    -e CHRONOS_HTTP_PORT=4400 \
    -e CHRONOS_MASTER=zk://node-1:2181,node-2:2181,node-3:2181/mesos \
    -e CHRONOS_ZK_HOSTS=node-1:2181,node-2:2181,node-3:2181 \
    --name chronos --net host --restart always mesoscloud/chronos:2.4.0-centos-7
```
