#!/bin/sh
set -x
echo "Starting service"
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/bin/mapred --daemon start historyserver
$HIVE_HOME/schematool -dbType mysql -initSchema
$HIVE_HOME/hive --service metastore
$HIVE_HOME/hive --service hiveserver2
