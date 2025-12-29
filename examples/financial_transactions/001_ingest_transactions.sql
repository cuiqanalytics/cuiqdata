-- Ingest raw financial transactions from CSV
CREATE OR REPLACE TABLE raw_transactions AS
SELECT * FROM read_csv_auto('./data/transactions.csv');
