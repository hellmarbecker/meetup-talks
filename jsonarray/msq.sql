REPLACE INTO "pizza-lineitems" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/Users/hellmarbecker/meetup-talks/jsonarray","filter":"*json"}',
      '{"type":"json"}'
    )
  ) EXTEND ("id" BIGINT, "shop" VARCHAR, "name" VARCHAR, "phoneNumber" VARCHAR, "address" VARCHAR, "pizzas" TYPE('COMPLEX<json>'), "timestamp" BIGINT)
)
SELECT
  MILLIS_TO_TIMESTAMP("timestamp") AS "__time",
  "id",
  "shop",
  "name",
  "phoneNumber",
  "address",
  JSON_VALUE(p, '$.pizzaName') AS pizzaName,
  JSON_QUERY(p, '$.additionalToppings') AS additionalToppings
FROM "ext" CROSS JOIN UNNEST(JSON_QUERY(pizzas, '$')) AS lineitems(p)
PARTITIONED BY DAY

REPLACE INTO "pizza-lineitems" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"local","baseDir":"/Users/hellmarbecker/meetup-talks/jsonarray","filter":"*json"}',
      '{"type":"json"}'
    )
  ) EXTEND ("id" BIGINT, "shop" VARCHAR, "name" VARCHAR, "phoneNumber" VARCHAR, "address" VARCHAR, "pizzas" TYPE('COMPLEX<json>'), "timestamp" BIGINT)
)
SELECT
  MILLIS_TO_TIMESTAMP("timestamp") AS "__time",
  "id",
  "shop",
  "name",
  "phoneNumber",
  "address",
  JSON_VALUE(p, '$.pizzaName') AS pizzaName,
  JSON_QUERY_ARRAY(p, '$.additionalToppings') AS additionalToppings
FROM "ext" CROSS JOIN UNNEST(JSON_QUERY_ARRAY(pizzas, '$')) AS lineitems(p)
PARTITIONED BY DAY

SELECT 
  JSON_QUERY_ARRAY("additionalToppings", '$'),
  JSON_QUERY("additionalToppings", '$')
FROM "pizza-lineitems"
