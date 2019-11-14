## Network
```
docker network create ICCD
```
## Jenkins
```
docker run -d -v ${HOME}/Documents/servers_data/jenkins_home:/var/jenkins_home -p
8080:8080 -p 50000:50000 --network ICCD --name jenkins jenkins/jenkins:lts
```
## Sonarqube
```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```
## Mysql
```
docker run --name mysql-ci -v ./custom_config_mysql.cnf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=admin -d mysql-ci:1
.0.0
```
## Artifactory
```
docker run --name my-artifactory -d -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss:latest
```
## Nexus
```
docker run -d -p 9001:8081 --network ICCD --name nexus sonatype/nexus3
```
## Registry
```
docker run --rm -d -p 5000:5000 --network ICCD --restart=always --name registry registry:2
```
## Simple UI for registry
```
docker run -d -p 5001:80 --network ICCD -e REGISTRY_URL=http://registry:5000 -e DELETE_IMAGES=true --name registry-ui joxit/docker-registry-ui:static
docker run -d -p 5001:8000 --network ICCD --name registry-ui quiq/docker-registry-ui
```
## Push local image
```
docker tag IMAGE_ID localhost:5000/IMAGE_NAME:VERSION
docker push localhost:5000/IMAGE_NAME:VERSION
```
## DNS server
Adminastration Web: https://localhost:10000
```
docker run --name dns -d --restart=always --publish 53:53/tcp --publish 53:53/udp --publish 10000:10000/tcp sameersbn/bind:9.11.3-20190706
```
