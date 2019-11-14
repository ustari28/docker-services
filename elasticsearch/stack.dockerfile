docker network create --driver bridge elk

docker run -d -p 9200:9200 -p 9300:9300 --network=elk -e "discovery.type=single-node" --name elasticsearch docker.elastic.co/elasticsearch/elasticsearch:7.4.2
docker run -d -p 5601:5601 -e ELASTICSEARCH_HOSTS=http://elasticsearch:9200 --network=elk --name kibana docker.elastic.co/kibana/kibana:7.4.2
docker run -d -p 2181:2181 -p 9092:9092 -e ADVERTISED_HOST=localhost -e ADVERTISED_PORT=9092 --network=elk --name kafka spotify/kafka
