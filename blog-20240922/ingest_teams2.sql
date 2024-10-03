REPLACE INTO "teams_nested" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"inline","data":"{ \"timestamp\": \"2024-09-01\", \"id\": \"1\", \"org\": { \"name\": \"Team 1\", \"members\": [ { \"name\": \"Alice\", \"gender\": \"F\" }, { \"name\": \"Bob\", \"gender\": \"M\" }, { \"name\": \"Carol\", \"gender\": \"F\" } ] } }\n{ \"timestamp\": \"2024-09-01\", \"id\": \"2\", \"org\": { \"name\": \"Team 2\", \"members\": [ { \"name\": \"Dan\", \"gender\": \"M\" }, { \"name\": \"Eve\", \"gender\": \"F\" }, { \"name\": \"Frank\", \"gender\": \"M\" } ] } }"}',
      '{"type":"json"}'
    )
  ) EXTEND ("timestamp" VARCHAR, "id" VARCHAR, "org" TYPE('COMPLEX<json>'))
)
SELECT
  TIME_PARSE(TRIM("timestamp")) AS "__time",
  "id",
  "org"
FROM "ext"
PARTITIONED BY DAY
