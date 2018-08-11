#docker build -f spark-slave.dockerfile --rm -t bigdata/spark-slave:1.0 .
#docker build -f spark-slave.dockerfile --rm -t bigdata/spark-slave:lastest .
FROM alpine:3.7
LABEL maintainer="ustargab@gmail.com"
LABEL version=1.0
LABEL description="Spark slave :)"
LABEL bigdata=spark-slave
ENV GLIBC_VERSION 2.27-r0
#basic utilities by correct work
RUN apk update && apk add --no-cache bash && \
    apk --no-cache add procps && \
    apk --update add coreutils && \
    apk --update add tar && \
    apk --update add rsync openssh
#glibc mandatory library
RUN apk add --update curl && \
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    apk add glibc-bin.apk glibc.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    apk del curl && \
    rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*
RUN mkdir -p /user/spark/home/spark-2.3.1
RUN mkdir -p /user/spark/home/java8
RUN wget http://apache.rediris.es/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz -P /tmp/ && \
    tar -zxf /tmp/spark-2.3.1-bin-hadoop2.7.tgz -C /tmp && \
    cp -R /tmp/spark-2.3.1-bin-hadoop2.7/** /user/spark/home/spark-2.3.1
COPY jdk-8u181-linux-x64.tar.gz /tmp/jdk-8u181-linux-x64.tar.gz
RUN tar -zxf /tmp/jdk-8u181-linux-x64.tar.gz -C /tmp && \
    cp -R /tmp/jdk1.8.0_181/** /user/spark/home/java8
COPY start-docker-slave.sh /user/spark/home/start-docker-slave.sh
RUN chmod 755 /user/spark/home/start-docker-slave.sh
ENV SPARK_HOME=/user/spark/home/spark-2.3.1
ENV JAVA_HOME=/user/spark/home/java8
#ENV PYTHONPATH=
ENV PATH=$PATH:$SPARK_HOME/sbin:$JAVA_HOME/bin
EXPOSE 8081
ENTRYPOINT ["/user/spark/home/start-docker-slave.sh"]
#docker run -dit -e SPARK_MASTER=spark://spark-master:7077 -p 8084:8081 --network=hadoop-cluster --link spark-master -v $HOME/Documents/ficheros-bd:$HOME/Documents/ficheros-bd  --rm --name spark-slave-antman bigdata/spark-slave:lastest "/bin/bash"
