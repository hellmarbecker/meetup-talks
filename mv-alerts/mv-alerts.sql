CREATE OR REPLACE TABLE urlslack (`text` String)
ENGINE = URL(
    'https://hooks.slack.com/services/<SLACK URL>', 
    JSONEachRow,
    headers(
        'Content-Type'='application/json',
        'Authentication'='Bearer <SLACK TOKEN>'
    )
);

CREATE OR REPLACE TABLE urlslack (`text` String)
ENGINE = URL(
    'https://webhook.site/71872b53-6732-49da-9d84-a19c37bb7842', 
    JSONEachRow,
    headers(
        'Content-Type'='application/json'
    )
);

INSERT INTO urlslack VALUES ('the quick brown fox');

INSERT INTO urlslack VALUES (null);

CREATE OR REPLACE TABLE urlvalues (
    `blurb` String,
    `val` Int64
)
ENGINE = MergeTree
ORDER BY (blurb);

CREATE OR REPLACE TABLE urlintermediate (
    `text` String
)
ENGINE = MergeTree
ORDER BY (text);

DROP VIEW urlalert;

CREATE MATERIALIZED VIEW urlalert TO urlslack AS
SELECT
    arrayStringConcat(groupArray(
        printf('Threshold value exceeded: (%s): %d', blurb, val) )) || ''
    AS `text`
FROM urlvalues
WHERE val > 10;

DROP VIEW urlalert2;

CREATE MATERIALIZED VIEW urlalert2 TO urlslack AS
SELECT * FROM urlintermediate;

INSERT INTO urlvalues VALUES
( 'v1', 2 ),
( 'v2', 1 );

SELECT
    arrayStringConcat(groupArray(printf('Threshold value exceeded: (%s): %d', blurb, val)))  AS `text`
FROM urlvalues
WHERE val > 10;

SELECT * FROM urlintermediate;

INSERT INTO urlvalues VALUES
( 'v3', 222 ),
( 'v4', 133 );

INSERT INTO urlslack VALUES ('');
