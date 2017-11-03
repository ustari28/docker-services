docker network create --driver bridge monitor
docker run --rm influxdb influxd config > influxdb.conf
docker run --name=my-influxdb -d -p 8086:8086 -p 8083:8083 -v $HOME/influxdb:/var/lib/influxdb \
-v $HOME/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro -e "INFLUXDB_ADMIN_ENABLED=true" \
-e "INFLUXDB_DB=telegraf" --network=monitor --hostname=influxdb influxdb

curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE telegraf"
curl -i -XPOST 'http://localhost:8086/write?db=telegraf' --data-binary 'cpu_load_short,host=server01,region=us-west
value=0.64 1434055562000000000'


docker run --name=my-telegraf -d -p 8094:8094 -v $HOME/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
--network=monitor --hostname=telegraf --link my-influxdb:influxdb telegraf

docker run -d -p 3000:3000 --name=my-grafana -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
-v $HOME/grafana:/var/lib/grafana:ro --network=monitor --hostname=grafana --link my-influxdb:influxdb grafana/grafana
