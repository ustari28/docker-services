#!/bin/bash
name=`cat /etc/hostname`
echo "Starting Spark $name"
start-slave.sh "$SPARK_MASTER"
#Extra line added in the script to run all command line arguments
exec "$@";
