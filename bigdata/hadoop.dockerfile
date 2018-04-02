version: '3'
services:
 db:
  image: "mysql"
  environment:
    - MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
  ports:
   - 3306:3306
  networks:
    - net-bigdata
 hadoop:
  ports:
   - 
  networks:
    - net-bigdata
  depends_on:
    - "db"
 hive:
  networks:
    - net-bigdata
  depends_on:
    - "hadoop"

networks:
  bigdata:
    driver: net-bigdata