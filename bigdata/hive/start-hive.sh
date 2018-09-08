#!/bin/bash
$HADOOP_HOME/bin/hadoop fs -mkdir -p /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse
$HADOOP_HOME/bin/hdfs dfs -put $SPARK_HOME/jars/** /spark-jars/
$HIVE_HOME/bin/schematool -initSchema -ifNotExists -dbType $DBTYPE
$HIVE_HOME/bin/hive --service metastore &
$HIVE_HOME/hcatalog/sbin/webhcat_server.sh start
$HIVE_HOME/bin/hive --service hiveserver2
exec "$@";
