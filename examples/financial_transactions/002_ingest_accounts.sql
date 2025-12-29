-- Ingest account master data with AML/KYC status
CREATE OR REPLACE TABLE raw_accounts AS
SELECT * FROM read_csv_auto('./data/accounts.csv');
