#!/bin/bash
name=`cat /etc/hostname`
echo "Starting hdfs cluster $name"
service ssh start
$HADOOP_HOME/bin/hdfs namenode -format "$CLUSTER_NAME"
ssh -o "StrictHostKeyChecking=accept-new" localhost "exit"
ssh -o "StrictHostKeyChecking=accept-new" $name "exit"
$HADOOP_HOME/bin/hdfs --daemon start namenode
#Extra line added in the script to run all command line arguments
exec "$@";
