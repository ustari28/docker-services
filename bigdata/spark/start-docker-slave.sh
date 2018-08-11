#!/bin/bash
start-slave.sh "$SPARK_MASTER"
#Extra line added in the script to run all command line arguments
exec "$@";
