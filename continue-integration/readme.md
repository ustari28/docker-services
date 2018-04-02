##Jenkins
```
docker run -d --name jenkins_ci -v ${HOME}/Documents/servers_data/jenkins_home:/var/jenkins_home -p 
8080:8080 -p 50000:50000 jenkins-ci:1.0.0
```
```
docker run -d --name jenkins_ci -p 8080:8080 -p 50000:50000 jenkins-ci:1.0.0
```
##Sonarqube
```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```
##Mysql
```
docker run --name mysql-ci -v ./custom_config_mysql.cnf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=admin -d mysql-ci:1
.0.0
```
##Artifactory
```
docker run --name my-artifactory -d -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss:latest
```
