#docker build -f hadoop-resourcemanager.dockerfile --rm -t bigdata/hadoop-resourcemanager:1.0 .
#docker build -f hadoop-resourcemanager.dockerfile --rm -t bigdata/hadoop-resourcemanager:lastest .
FROM ubuntu
LABEL maintainer="ustargab@gmail.com"
LABEL version=1.0
LABEL description="Hadoop Resource Manager"
LABEL bigdata=resourcemanager
ENV HOME_HOST="/user/hadoop"
#basic utilities by correct work
RUN apt-get update && apt-get install openssh-server -y && \
    apt-get install software-properties-common -y
RUN mkdir -p $HOME_HOST/home/java8 && mkdir -p $HOME_HOST/home/hadoop-3.1.1 && \
    mkdir -p $HOME_HOST/nn && mkdir -p $HOME_HOST/dn && mkdir -p $HOME_HOST/log && \
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
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

COPY start-resourcemanager.sh $HOME_HOST/start-resourcemanager.sh
COPY hadoop-env.sh $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/hadoop-env.sh
COPY core-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/core-site.xml
COPY yarn-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/yarn-site.xml
COPY mapred-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/mapred-site.xml
COPY hdfs-site.xml $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/hdfs-site.xml
RUN chmod 755 $HOME_HOST/start-resourcemanager.sh && \
    chmod 755 $HOME_HOST/home/hadoop-3.1.1/etc/hadoop/*.sh

ENV HADOOP_HOME=$HOME_HOST/home/hadoop-3.1.1
#ENV HADOOP_PREFIX=$HADOOP_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH=$PATH:$HADOOP_HOME/bin:$JAVA_HOME/bin
ENV CLUSTER_NAME="hadoop_cluster"
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV HDFS_JOURNALNODE_USER="root"
ENV YARN_LOGS="$HOME_HOST/log"
ENV YARN_SPREAD="$HOME_HOST/spread"
ENV CVS_RSH=ssh
ENTRYPOINT ["/user/hadoop/start-resourcemanager.sh"]
#docker network create --driver bridge hadoop-cluster
#docker run -dit -p 8088:8088 --name resourcemanager --network=hadoop-cluster --link namenode -h resourcemanager bigdata/hadoop-resourcemanager:1.0 "/bin/bash"
