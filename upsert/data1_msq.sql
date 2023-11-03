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
PARTITIONED BY DAY
