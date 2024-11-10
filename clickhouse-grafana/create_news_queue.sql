CREATE DATABASE `world-news`;

USE `world-news`;

CREATE TABLE news_queue
(
    timestamp Float64, -- use toDateTime in MV
    recordType LowCardinality(String),
    url String,
    useragent String,
    statuscode LowCardinality(String),
    state LowCardinality(String),
    statesVisited Array(String),
    sid Int64,
    uid String,
    isSubscriber Int32,
    campaign LowCardinality(String),
    channel LowCardinality(String),
    contentId LowCardinality(String),
    subContentId String,
    gender LowCardinality(String),
    age LowCardinality(String),
    latitude Float64,
    longitude Float64,
    place_name String,
    country_code LowCardinality(String),
    timezone LowCardinality(String)
)
ENGINE = Kafka('kafka:9092', 'world-news', 'clickhouse', 'JSONEachRow')
     SETTINGS kafka_thread_per_consumer = 0, kafka_num_consumers = 1;

CREATE TABLE news
(
    timestamp Float64, -- use toDateTime in MV
    recordType LowCardinality(String),
    url String,
    useragent String,
    statuscode LowCardinality(String),
    state LowCardinality(String),
    statesVisited Array(String),
    sid Int64,
    uid String,
    isSubscriber Int32,
    campaign LowCardinality(String),
    channel LowCardinality(String),
    contentId LowCardinality(String),
    subContentId String,
    gender LowCardinality(String),
    age LowCardinality(String),
    latitude Float64,
    longitude Float64,
    place_name String,
    country_code LowCardinality(String),
    timezone LowCardinality(String)
)
ENGINE = MergeTree ORDER BY (uid, sid, timestamp);

CREATE MATERIALIZED VIEW news_mv TO news AS
SELECT * FROM news_queue;

