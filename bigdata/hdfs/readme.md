# HDFS
Small HDFS system. You can start up a hdfs namenode and N datanodes, depend
on yours resources.
Create a intranet:
```shell
docker network create --driver bridge hadoop-cluster
```
Build namenode:
```shell
docker build -f hadoop-hdfs-namenode.dockerfile --rm -t bigdata/hadoop-hdfs-namenode:lastest .
```
Build datanode
```shell
docker build -f hadoop-hdfs-namenode.dockerfile --rm -t bigdata/hadoop-hdfs-namenode:lastest .
```
Start up namenode:
```shell
docker run -dit -p 9870:9870 -p 9000:9000 --name namenode --network=hadoop-cluster  -h namenode bigdata/hadoop-hdfs-namenode:lastest "/bin/bash"
```
Start up datanode:
```shell
docker run -dit --name datanode --network=hadoop-cluster --link namenode -h datanode bigdata/hadoop-hdfs-datanode:lastest "/bin/bash"
```
