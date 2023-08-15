CREATE DATABASE iceberg_test;


CREATE TABLE iceberg_test.iceberg_testdata (
  ts  TIMESTAMP,
  key STRING,
  val DOUBLE
)
PARTITIONED BY ( month(ts) )
LOCATION 's3://hbecker-us-east-1/iceberg_testdata/'
TBLPROPERTIES ( 'table_type'='ICEBERG' );


INSERT INTO iceberg_test.iceberg_testdata VALUES (TIMESTAMP'2023-08-15', 'a1', 23.9);
