#!/bin/bash
name=`cat /etc/hostname`
echo "Starting Spark $name"
start-master.sh
#Extra line added in the script to run all command line arguments
exec "$@";
