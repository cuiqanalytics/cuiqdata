-- Ingest counterparty information with AML/sanctions status
CREATE OR REPLACE TABLE raw_counterparties AS
SELECT * FROM read_csv_auto('./data/counterparties.csv');
