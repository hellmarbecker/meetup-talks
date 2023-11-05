-- populate main table

REPLACE INTO "data1" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/Users/hellmarbecker/meetup-talks/upsert","filter":"data1.json"}',
      '{"type":"json"}'
    )
  ) EXTEND ("date" VARCHAR, "ad_network" VARCHAR, "ads_impressions" BIGINT, "ads_revenue" DOUBLE)
)
SELECT
  TIME_PARSE("date") AS "__time",
  "ad_network",
  "ads_impressions",
  "ads_revenue"
FROM "ext"
PARTITIONED BY MONTH
CLUSTERED BY "ad_network"


-- populate upsert staging table (leave this out)

REPLACE INTO "data2" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/Users/hellmarbecker/meetup-talks/upsert","filter":"data2.json"}',
      '{"type":"json"}'
    )
  ) EXTEND ("date" VARCHAR, "ad_network" VARCHAR, "ads_impressions" BIGINT, "ads_revenue" DOUBLE)
)
SELECT
  TIME_PARSE("date") AS "__time",
  "ad_network",
  "ads_impressions",
  "ads_revenue"
FROM "ext"
PARTITIONED BY MONTH
CLUSTERED BY "ad_network"


-- filter out main table data to staging table

REPLACE INTO "data1-staging" OVERWRITE ALL
SELECT *
FROM "data1"
WHERE NOT (
  __time >= TIMESTAMP'2023-01-03' AND __time < TIMESTAMP'2023-01-10'
  AND "ad_network" = 'gaagle'
)
PARTITIONED BY MONTH
CLUSTERED BY "ad_network"


-- add new data. this creates a dynamic segment in the staging table

INSERT INTO "data1-staging"
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/Users/hellmarbecker/meetup-talks/upsert","filter":"data2.json"}',
      '{"type":"json"}'
    )
  ) EXTEND ("date" VARCHAR, "ad_network" VARCHAR, "ads_impressions" BIGINT, "ads_revenue" DOUBLE)
)
SELECT
  TIME_PARSE("date") AS "__time",
  "ad_network",
  "ads_impressions",
  "ads_revenue"
FROM "ext"
PARTITIONED BY MONTH
CLUSTERED BY "ad_network"


-- swap data back into main table, restoring the partitioning

REPLACE INTO "data1" OVERWRITE ALL
SELECT *
FROM "data1-staging"
PARTITIONED BY MONTH
CLUSTERED BY "ad_network"






