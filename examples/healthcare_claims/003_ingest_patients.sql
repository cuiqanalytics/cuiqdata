-- Ingest patient demographics from CSV
CREATE OR REPLACE TABLE raw_patients AS
SELECT * FROM read_csv_auto('./data/patients.csv');
