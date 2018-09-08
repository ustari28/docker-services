#!/bin/bash
name=`cat /etc/hostname`
echo "Starting historyserver $name"
service ssh start
ssh -o "StrictHostKeyChecking=accept-new" localhost "exit"
ssh -o "StrictHostKeyChecking=accept-new" $name "exit"
$HADOOP_HOME/bin/mapred --daemon start historyserver
#Extra line added in the script to run all command line arguments
exec "$@";
