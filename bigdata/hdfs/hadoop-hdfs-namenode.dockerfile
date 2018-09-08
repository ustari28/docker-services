#docker build -f hadoop-hdfs-namenode.dockerfile --rm -t bigdata/hadoop-hdfs-namenode:3.0 .
#docker build -f hadoop-hdfs-namenode.dockerfile --rm -t bigdata/hadoop-hdfs-namenode:lastest .
FROM ubuntu
LABEL maintainer="ustargab@gmail.com"
LABEL version=1.0
LABEL description="Hadoop HDFS"
LABEL bigdata=hdfs
LABEL hdfs=namenode
ENV HOME_HOST="/user/hadoop"
#basic utilities by correct work
RUN apt-get update && apt-get install openssh-server -y && \
    apt-get install software-properties-common -y
RUN mkdir -p $HOME_HOST/home/java8 && mkdir -p $HOME_HOST/home/hadoop-3.1.1 && \
    mkdir -p $HOME_HOST/nn && mkdir -p $HOME_HOST/dn
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
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

COPY start-hdfs-namenode.sh $HOME_HOST/home/start-hdfs-namenode.sh
COPY hadoop-env.sh $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/hadoop-env.sh
COPY core-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/core-site.xml
COPY yarn-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/yarn-site.xml
COPY mapred-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/mapred-site.xml
COPY hdfs-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/hdfs-site.xml
RUN chmod 755 $HOME_HOST/home/start-hdfs-namenode.sh && \
    chmod 755 $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/*.sh

ENV HADOOP_HOME=$HOME_HOST/home/hadoop-3.1.1
#ENV HADOOP_PREFIX=$HADOOP_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH=$PATH:$HADOOP_HOME/bin:$JAVA_HOME/bin
ENV NAMENODE_URI=hdfs://namenode:9000/
ENV CLUSTER_NAME="hadoop_cluster"
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV HDFS_JOURNALNODE_USER="root"
ENV CVS_RSH=ssh
ENTRYPOINT ["/user/hadoop/home/start-hdfs-namenode.sh"]
#docker network create --driver bridge hadoop-cluster
#docker run -dit -p 9870:9870 -p 9000:9000 --name namenode --network=hadoop-cluster  -h namenode bigdata/hadoop-hdfs-namenode:3.0 "/bin/bash"
