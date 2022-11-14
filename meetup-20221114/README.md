# Kafka, KSQL and Schema Registry to build a real time analytics pipeline into Druid(Imply)

### Start Imply

```
cd imply-2022.10 
bin/supervise -c conf/supervise/quickstart.conf
```

Druid Console at localhost:8888, Pivot at localhost:9095

### Start Kafka

```
docker compose up -d
```



### Log into KSQL

```
docker-compose exec ksqldb-cli ksql http://ksqldb-server:8088
```

### Start the generator

```
python3 ./news_process.py -f news_config_meetup.yml
```

Use `kcat -b localhost:9092 -t imply-news -C` to view messages as they are generated
