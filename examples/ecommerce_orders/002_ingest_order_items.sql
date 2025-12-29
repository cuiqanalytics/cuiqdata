-- Ingest order line items from CSV
-- This creates the raw_order_items table with item-level detail
CREATE OR REPLACE TABLE raw_order_items AS
SELECT * FROM read_csv_auto('./data/order_items.csv');
