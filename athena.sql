CREATE TABLE testdata.testdata (
  ts  TIMESTAMP,
  key STRING,
  val DOUBLE
)
PARTITIONED BY ( month(ts) )
LOCATION 's3://hbecker-us-east1/testdata/'
TBLPROPERTIES ( 'table_type'='ICEBERG' );
