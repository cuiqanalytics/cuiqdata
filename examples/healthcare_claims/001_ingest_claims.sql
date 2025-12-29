-- Ingest raw insurance claims from CSV
CREATE OR REPLACE TABLE raw_claims AS
SELECT * FROM read_csv_auto('./data/claims.csv');
