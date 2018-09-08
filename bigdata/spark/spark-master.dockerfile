#docker build -f spark-master.dockerfile --rm -t bigdata/spark-master:2.0 .
#docker build -f spark-master.dockerfile --rm -t bigdata/spark-master:lastest .
FROM openjdk:alpine
LABEL maintainer="ustargab@gmail.com"
LABEL version=1.0
LABEL description="Spark master node"
LABEL bigdata=spark-master
#basic utilities by correct work
RUN apk update && apk add --no-cache bash && \
    apk --no-cache add procps && \
    apk --update add coreutils && \
    apk --update add tar
RUN mkdir -p /user/spark/home/spark-2.3.1
RUN wget http://apache.rediris.es/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz -P /tmp/ && \
    tar -zxf /tmp/spark-2.3.1-bin-hadoop2.7.tgz -C /tmp && \
    cp -R /tmp/spark-2.3.1-bin-hadoop2.7/** /user/spark/home/spark-2.3.1
RUN rm -rf /tmp/**
COPY start-docker-master.sh /user/spark/home/start-docker-master.sh
RUN chmod 755 /user/spark/home/start-docker-master.sh
ENV SPARK_HOME=/user/spark/home/spark-2.3.1
ENV PATH=$PATH:$SPARK_HOME/sbin
ENV CVS_RSH=ssh
EXPOSE 7077 8080
ENTRYPOINT ["/user/spark/home/start-docker-master.sh"]
#docker run -dit -p 7077:7077 -p 8080:8080 --network=hadoop-cluster --hostname spark-master -v $HOME/Documents/ficheros-bd:$HOME/Documents/ficheros-bd --rm --name spark-master bigdata/spark-master:2.0 "/bin/bash"
