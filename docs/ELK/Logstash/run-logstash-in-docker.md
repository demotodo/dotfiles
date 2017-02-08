## Dockerfile

```dockerfile
FROM centos:7

RUN yum install -y java-1.7.0-openjdk-headless tar

RUN curl -fL https://download.elastic.co/logstash/logstash/logstash-1.5.4.tar.gz | tar xzf - -C /opt && \
mv /opt/logstash-1.5.4 /opt/logstash

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/logstash/bin

CMD ["logstash"]
```


## Run Docker container

```bash
docker run -d \
    -v /srv/events:/srv/events \
    -v /srv/logstash:/srv/logstash \
    --name=logstash --restart=always mesoscloud/logstash:1.5.4-centos-7 \
    logstash -e 'input { file { path => "/srv/events/containers.log-*" codec => json sincedb_path => "/srv/logstash/sincedb" } } output { elasticsearch { } }'
```
