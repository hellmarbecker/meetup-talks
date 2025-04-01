-- table world-news

CREATE TABLE default.`world-news`
(
    `affiliateLink` Int64,
    `age` String,
    `campaign` String,
    `channel` String,
    `clickbait` Int64,
    `content` Int64,
    `country_code` String,
    `exitSession` Int64,
    `gender` String,
    `home` Int64,
    `isSubscriber` Int64,
    `latitude` Float64,
    `longitude` Float64,
    `place_name` String,
    `plusContent` Int64,
    `recordType` String,
    `sid` String,
    `statesVisited` Array(String),
    `subscribe` Int64,
    `timestamp` DateTime,
    `timezone` String,
    `uid` String,
    `useragent` String,
    `_key` String,
    `_timestamp` DateTime64(3),
    `_partition` Int32,
    `_offset` Int64,
    `_topic` String,
    `_header_keys` Array(String),
    `_header_values` Array(String),
    `contentId` String,
    `state` String,
    `statuscode` Int64,
    `subContentId` String,
    `url` String
)
ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
ORDER BY (toStartOfDay(timestamp), uid)
SETTINGS index_granularity = 8192
