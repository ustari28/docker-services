# Resource manager
Small Resource manager system. You can start up a resource manager and N node managers, depend
on yours resources.
Create a intranet:
```shell
docker network create --driver bridge hadoop-cluster
```
Build resourcemanager:
```shell
docker build -f hadoop-resourcemanager.dockerfile --rm -t bigdata/hadoop-resourcemanager:lastest .
```
Build nodemanager
```shell
docker build -f hadoop-nodemanager.dockerfile --rm -t bigdata/hadoop-nodemanager:lastest .
```
Build History server:
```shell
docker build -f hadoop-historyserver.dockerfile --rm -t bigdata/hadoop-historyserver:lastest .
```
Start up resourcemanager:
```shell
docker run -dit -p 8088:8088 --name resourcemanager --network=hadoop-cluster --link namenode -h resourcemanager bigdata/hadoop-resourcemanager:lastest "/bin/bash"
```
Start up NodeManager:
```shell
docker run -dit --name nodemanager1 --network=hadoop-cluster --link resourcemanager -h nodemanager1 bigdata/hadoop-nodemanager:lastest "/bin/bash"
```
Start up history server:
```shell
docker run -dit -p 19888:19888 --name historyserver --network=hadoop-cluster --link namenode --link resourcemanager -h historyserver bigdata/hadoop-historyserver:lastest "/bin/bash"
```
