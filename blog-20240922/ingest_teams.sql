REPLACE INTO "inline_data" OVERWRITE ALL
WITH "ext" AS (
  SELECT *
  FROM TABLE(
    EXTERN(
      '{"type":"inline","data":"timestamp|team|members\n2024-09-01|Team 1|[{ \"name\": \"Alice\", \"gender\": \"F\" }, { \"name\": \"Bob\", \"gender\": \"M\" }, { \"name\": \"Carol\", \"gender\": \"F\" }]\n2024-09-01|Team 2|[{ \"name\": \"Dan\", \"gender\": \"M\" }, { \"name\": \"Eve\", \"gender\": \"F\" }, { \"name\": \"Frank\", \"gender\": \"M\" }]"}',
      '{"type":"tsv","delimiter":"|","findColumnsFromHeader":true}'
    )
  ) EXTEND ("timestamp" VARCHAR, "team" VARCHAR, "members" VARCHAR)
)
SELECT
  TIME_PARSE(TRIM("timestamp")) AS "__time",
  "team",
  PARSE_JSON("members") AS "members"
FROM "ext"
PARTITIONED BY DAY
