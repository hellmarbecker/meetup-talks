-- UNION with an external table is not supported yet, so this fails to plan
REPLACE INTO "data1" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/Users/hellmarbecker/meetup-talks/upsert","filter":"data2.json"}',
      '{"type":"json"}'
    )
  ) EXTEND ("date" VARCHAR, "ad_network" VARCHAR, "ads_impressions" BIGINT, "ads_revenue" DOUBLE)
)
SELECT *
FROM "data1"
WHERE ad_network <> 'gaagle'
UNION ALL
SELECT
  TIME_PARSE("date") AS "__time",
  "ad_network",
  "ads_impressions",
  "ads_revenue"
FROM "ext"
WHERE ad_network = 'gaagle'
PARTITIONED BY DAY
