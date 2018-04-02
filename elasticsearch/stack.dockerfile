docker run -d -p 9200:9200 -p 9300:9300 -v $HOME/Documents/docker/elasticsearch/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:rw -v $HOME/Documents/docker/elasticsearch/data:/usr/share/elasticsearch/data:rw -e "discovery.type=single-node" --name my-elasticsearch docker.elastic.co/elasticsearch/elasticsearch:6.0.0
docker run -p docker.elastic.co/kibana/kibana:6.0.0
