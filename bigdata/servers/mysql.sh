docker run -dit -p 3306:3306 --name mysqlserver -e MYSQL_ROOT_PASSWORD="s3cr3t" \
 -e MYSQL_DATABASE="metastore" -e MYSQL_USER="hive" \
 -e MYSQL_PASSWORD="h1v3" --network=hadoop-cluster -h mysqlserver mysql
