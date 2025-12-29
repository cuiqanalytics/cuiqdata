-- Ingest raw order data from CSV
-- This creates the raw_orders table with order-level information
CREATE OR REPLACE TABLE raw_orders AS
SELECT * FROM read_csv_auto('./data/orders.csv');
