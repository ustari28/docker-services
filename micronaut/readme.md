# zipkin
docker run -d -p 9411:9411 -e STORAGE_TYPE=elasticsearch -e ES_HOSTS=http://elasticsearch.local:9200 -e KAFKA_BOOTSTRAP_SERVERS=kafka.local:9092 --network elk --name zipkin openzipkin/zipkin-slim
