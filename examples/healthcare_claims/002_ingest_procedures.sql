-- Ingest procedure codes and charges from CSV
CREATE OR REPLACE TABLE raw_procedures AS
SELECT * FROM read_csv_auto('./data/procedures.csv');
