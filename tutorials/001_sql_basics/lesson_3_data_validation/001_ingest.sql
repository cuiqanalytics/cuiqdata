-- LESSON 3 - Step 1: Checking and loading data
-- 
-- In this step, we will check the data for any issues before loading it into the database.
--
-- First run the preview_rows.sql script to see the first 10 rows of the raw_subscriptions table:
-- 
-- `cuiqdata exec . preview_rows.sql`
-- 
-- Notice the errors in `subscription_tier` field? We will fix them in the next step.
-- Before that, let's create a table to store the raw data
--
-- Run the pipeline: `cuiqdata run .`

CREATE OR REPLACE TABLE raw_subscriptions AS
SELECT * FROM read_csv_auto('./subscriptions.csv',all_varchar=true);