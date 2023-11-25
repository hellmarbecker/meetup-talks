-- populate main table

REPLACE INTO "ad_data" OVERWRITE ALL
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

-- merge query

-- add query context:
-- { "sqlJoinAlgorithm": "sortMerge" }
  
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
  COALESCE("new_data"."__time", "ad_data"."__time") AS "__time",
  COALESCE("new_data"."ad_network", "ad_data"."ad_network") AS "ad_network",
  CASE WHEN "new_data"."ad_network" IS NOT NULL THEN "new_data"."ads_impressions" ELSE "ad_data"."ads_impressions" END AS "ads_impressions",
  CASE WHEN "new_data"."ad_network" IS NOT NULL THEN "new_data"."ads_revenue" ELSE "ad_data"."ads_revenue" END AS "ads_revenue"
FROM
  "ad_data"
FULL OUTER JOIN
  ( SELECT
    TIME_PARSE("date") AS "__time",
    "ad_network",
    "ads_impressions",
    "ads_revenue"
  FROM "ext" ) "new_data"
ON "ad_data"."__time" = "new_data"."__time" AND "ad_data"."ad_network" = "new_data"."ad_network"

