#docker build -f hadoop-hive.dockerfile --rm -t bigdata/hadoop-hive:1.0 .
#docker build -f hadoop-hive.dockerfile --rm -t bigdata/hadoop-hive:lastest .
FROM ubuntu
LABEL maintainer="ustargab@gmail.com"
LABEL version=1.0
LABEL description="Hadoop Hive"
LABEL bigdata=hive
LABEL hive=mysql
ENV HOME_HOST="/user/hive"
#basic utilities by correct work
RUN apt-get update && apt-get install openssh-server -y && \
    apt-get install software-properties-common -y
RUN mkdir -p $HOME_HOST/home/java8 && mkdir -p $HOME_HOST/home/hadoop-3.1.1 && \
    mkdir -p $HOME_HOST/nn && mkdir -p $HOME_HOST/dn && \
    mkdir -p $HOME_HOST/apache-hive-3.1.0-bin && \
    mkdir -p $HOME_HOST/spark-2.3.1 && \
    mkdir -p $HOME_HOST/log && \
    mkdir -p $HOME_HOST/spread
# Install Java.
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer
#Install hadoop
RUN wget -q http://apache.rediris.es/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz -P /tmp/ && \
    tar -zxf /tmp/hadoop-3.1.1.tar.gz -C /tmp && \
    cp -R /tmp/hadoop-3.1.1/** $HOME_HOST/home/hadoop-3.1.1
RUN wget -q http://apache.rediris.es/hive/hive-3.1.0/apache-hive-3.1.0-bin.tar.gz -P /tmp/ && \
    tar -zxf /tmp/apache-hive-3.1.0-bin.tar.gz -C /tmp && \
    cp -R /tmp/apache-hive-3.1.0-bin/** $HOME_HOST/apache-hive-3.1.0-bin
RUN wget http://apache.rediris.es/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz -P /tmp/ && \
    tar -zxf /tmp/spark-2.3.1-bin-hadoop2.7.tgz -C /tmp && \
    cp -R /tmp/spark-2.3.1-bin-hadoop2.7/** $HOME_HOST/spark-2.3.1

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys
RUN rm -rf /tmp/**

COPY start-hive.sh $HOME_HOST/start-hive.sh
COPY hadoop-env.sh $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/hadoop-env.sh
COPY core-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/core-site.xml
COPY yarn-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/yarn-site.xml
COPY mapred-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/mapred-site.xml
COPY hdfs-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/hdfs-site.xml
COPY hive-site.xml $HOME_HOST/apache-hive-3.1.0-bin/conf/hive-site.xml
COPY hive-log4j2.properties $HOME_HOST/apache-hive-3.1.0-bin/conf/hive-log4j2.properties
COPY spark-defaults.conf /user/spark/home/spark-2.3.1/conf/spark-defaults.conf
COPY mysql-connector-java-8.0.12.jar $HOME_HOST/apache-hive-3.1.0-bin/lib/mysql-connector-java-8.0.12.jar
RUN chmod 755 $HOME_HOST/start-hive.sh && \
    chmod 755 $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/*.sh

ENV HADOOP_HOME=$HOME_HOST/home/hadoop-3.1.1
ENV HIVE_HOME=$HOME_HOST/apache-hive-3.1.0-bin
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH=$PATH:$HADOOP_HOME/bin:$JAVA_HOME/bin:$HIVE_HOME/bin
ENV CLUSTER_NAME="hadoop_cluster"
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HCAT_LOG_DIR=/var/log
ENV DBTYPE=mysql
ENV SPARK_HOME=$HOME_HOST/spark-2.3.1
ENV PATH=$PATH:$SPARK_HOME/sbin:$JAVA_HOME/bin:$HIVE_HOME/bin
ENV HOME=$HOME_HOST
ENV YARN_LOGS="$HOME_HOST/log"
ENV YARN_SPREAD="$HOME_HOST/spread"
ENV CVS_RSH=ssh

ENTRYPOINT ["/user/hive/start-hive.sh"]
#docker network create --driver bridge hadoop-cluster
#docker run -dit -p 10002:10002 -p 8188:8188 -p 10001:10001 --rm --name hiveserver --network=hadoop-cluster --link namenode --link mysqlserver  -h hiveserver bigdata/hadoop-hive:1.0 "/bin/bash"
