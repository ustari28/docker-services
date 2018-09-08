# Hive
Hive server
## Building
```sh
docker build -f hadoop-hive.dockerfile --rm -t bigdata/hadoop-hive:lastest .
```
## Start
```sh
docker run -dit -p 10002:10002 -p 10001:10001 --rm --name hiveserver --network=hadoop-cluster --link namenode --link mysqlserver  -h hiveserver bigdata/hadoop-hive:1.0 "/bin/bash"
```
