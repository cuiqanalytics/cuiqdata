-- LEVEL 2 - Step 1: Ingest Raw Data
-- 
-- Goal:
--   Load the data into a 'raw' table without any transformations.
--   This is your single source of truth for debugging.
-- 
-- Best Practice:
--   NEVER transform data in the ingest step. If you later discover issues
--   with your cleaning logic (step 002), you can re-run step 002 without
--   re-downloading the data.
-- 
-- DuckDB Magic:
--   read_csv_auto() automatically sniffs column types based on data values.
--   This saves time, but always verify the types in step 002.
-- 

CREATE OR REPLACE TABLE raw_orders AS
SELECT * FROM read_csv_auto('./data/messy_orders.csv', all_varchar=true);

-- Tip: Inspect what we just loaded
-- SELECT 
--     COUNT(*) as total_rows,
--     COUNT(DISTINCT "Order ID") as unique_orders
-- FROM raw_orders;
