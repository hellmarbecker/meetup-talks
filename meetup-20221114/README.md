# Kafka, KSQL and Schema Registry to build a real time analytics pipeline into Druid(Imply)

### Imply Configuration Settings

#### conf/druid/broker/jvm.config
```
-Xms512m
-Xmx512m
-XX:MaxDirectMemorySize=768m
-XX:+UseG1GC
```
#### conf/druid/broker/runtime.properties
```
druid.server.http.numThreads=12
druid.broker.http.maxQueuedBytes=5MiB
druid.processing.buffer.sizeBytes=100MiB
```
#### conf/druid/historical/jvm.config
```
-Xms512m
-Xmx512m
-XX:MaxDirectMemorySize=1280m
-XX:+UseG1GC
```
#### conf/druid/historical/runtime.properties
```
druid.server.http.numThreads=12
druid.processing.buffer.sizeBytes=200MiB
druid.processing.numThreads=2
druid.segmentCache.locations=[{"path":"var/druid/segment-cache","maxSize":"300g"}]
druid.cache.sizeInBytes=10MiB
```

and remove `druid.server.maxSize`

#### conf/druid/middleManager/jvm.config
```
-Xms64m
-Xmx64m
-XX:+UseG1GC
```
#### conf/druid/middleManager/runtime.properties
```
druid.worker.capacity=2
druid.indexer.runner.javaCommand=bin/run-java
druid.indexer.runner.javaOptsArray=["-server","-Xms1g","-Xmx1g","-XX:MaxDirectMemorySize=1g","-Duser.timezone=UTC","-Dfile.encoding=UTF-8","-XX:+ExitOnOutOfMemoryError","-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"]
druid.server.http.numThreads=12
druid.indexer.fork.property.druid.processing.numMergeBuffers=2
druid.indexer.fork.property.druid.processing.buffer.sizeBytes=100MiB
druid.indexer.fork.property.druid.processing.numThreads=1
```
#### conf/druid/router/jvm.config
```
-Xms128m
-Xmx128m
-XX:MaxDirectMemorySize=128m
```
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
