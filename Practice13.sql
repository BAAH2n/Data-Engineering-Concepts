INSTALL httpfs;
LOAD httpfs;

SET s3_region='us-east-1';
SET s3_access_key_id='minioadmin';
SET s3_secret_access_key='minioadmin';
SET s3_endpoint='http://127.0.0.1:9000';

SELECT * FROM read_csv_auto('s3://my-dbt-source/my_data.csv');

