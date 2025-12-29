-- LESSON 3 - Step 1: Preview rows
-- 
-- To preview rows, we can use SQL queries to select a subset of the data.
-- In this case, we are selecting the first 10 rows from the raw_subscriptions table.
--
-- To execute this query, you can run the following command:
---
--- `cuiqdata exec . preview_rows.sql`

SELECT * FROM raw_subscriptions LIMIT 10;

-- 
-- Note: You can also pass the query directly between double quotes:
-- 
-- `cuiqdata exec . "SELECT * FROM raw_subscriptions LIMIT 10;"`
