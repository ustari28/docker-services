#!/bin/bash
name=`cat /etc/hostname`
echo "Starting resourcemanager $name"
service ssh start
ssh -o "StrictHostKeyChecking=accept-new" localhost "exit"
ssh -o "StrictHostKeyChecking=accept-new" $name "exit"
$HADOOP_HOME/bin/yarn --daemon start resourcemanager
#Extra line added in the script to run all command line arguments
exec "$@";
