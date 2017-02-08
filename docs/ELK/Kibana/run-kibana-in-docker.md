## Dockerfile

```dockerfile
FROM centos:7

RUN yum install -y java-1.7.0-openjdk-headless tar

RUN curl -fL https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz | tar xzf - -C /opt && \
mv /opt/kibana-4.1.2-linux-x64 /opt/kibana

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/kibana/bin

CMD ["kibana"]

EXPOSE 5601
```

### entrypoint.sh

```bash
#!/bin/sh

ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST:-localhost}
ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT:-9200}

if [ $ELASTICSEARCH_HOST = gateway ]; then
    ELASTICSEARCH_HOST=`ip route | grep ^default | awk '{print $3}'`
fi

sed -i "s/^elasticsearch_url: .*/elasticsearch_url: \"http:\/\/$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT\"/" /opt/kibana/config/kibana.yml

exec "$@"
```


## Run Docker container

```bash
docker run -d \
    --name=kibana --net=host --restart=always mesoscloud/kibana:4.1.2-centos-7
    
docker run -d \
    -e ELASTICSEARCH_HOST=gateway \
    -p 5601:5601 \
    --name=kibana --restart=always mesoscloud/kibana:4.1.2-centos-7
```
