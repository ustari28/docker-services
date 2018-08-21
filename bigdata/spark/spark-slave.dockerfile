#docker build -f spark-slave.dockerfile --rm -t bigdata/spark-slave:2.0 .
#docker build -f spark-slave.dockerfile --rm -t bigdata/spark-slave:lastest .
FROM java:alpine
LABEL maintainer="ustargab@gmail.com"
LABEL version=1.0
LABEL description="Spark slave :)"
LABEL bigdata=spark-slave
#basic utilities by correct work
RUN apk update && apk add --no-cache bash && \
    apk --no-cache add procps && \
    apk --update add coreutils && \
    apk --update add tar && \
    apk --update add rsync openssh
RUN mkdir -p /user/spark/home/spark-2.3.1
RUN wget http://apache.rediris.es/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz -P /tmp/ && \
    tar -zxf /tmp/spark-2.3.1-bin-hadoop2.7.tgz -C /tmp && \
    cp -R /tmp/spark-2.3.1-bin-hadoop2.7/** /user/spark/home/spark-2.3.1
COPY start-docker-slave.sh /user/spark/home/start-docker-slave.sh
RUN chmod 755 /user/spark/home/start-docker-slave.sh
RUN rm -rf /tmp/**
ENV SPARK_HOME=/user/spark/home/spark-2.3.1
#ENV PYTHONPATH=
ENV PATH=$PATH:$SPARK_HOME/sbin
EXPOSE 8081
ENTRYPOINT ["/user/spark/home/start-docker-slave.sh"]
#docker run -dit -e SPARK_MASTER=spark://spark-master:7077 -p 8081:8081 --network=hadoop-cluster --link spark-master --hostname spark-slave-thor -v $HOME/Documents/ficheros-bd:$HOME/Documents/ficheros-bd  --rm --name spark-slave-thor bigdata/spark-slave:2.0 "/bin/bash"
