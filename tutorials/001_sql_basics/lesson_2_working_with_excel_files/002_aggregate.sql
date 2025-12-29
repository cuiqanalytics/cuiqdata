-- LESSON 2 - Step 2: Aggregate Data
-- 
-- Goals:
--   Build a summary report from the purchases data. In particular:
--      - Number of items sold per category
--      - Total sales per category
--      - Average price per category    
--
-- Tasks:
--      - Create a new table called 'sales_summary' with the following columns:
--          category
--          num_items_sold
--          total_sales
--          average_price
--
--      - Test and preview the pipeline
--      - Output to new Excel file called 'sales_summary.xlsx'
--
-- What you will learn:
--  - Use the GROUP BY clause to group the data by category
--  - Use the SUM function to calculate the total sales
--  - Use the COUNT function to calculate the number of items sold
--  - Use the AVG function to calculate the average price
--  - Use the preview capabilities from cuiqdata

-- serial_id;first_name;last_name;amount(1000,2000);category

CREATE OR REPLACE TABLE sales_summary AS
SELECT 
    -- The group on which we will calculate the metrics:
    category, 
    -- COUNT(*) means count all records that belong to each group:
    COUNT(*) AS num_items_sold, 
    -- SUM sums all values from the field for each value of the group 'category': 
    SUM(amount) AS total_sales, 
    -- AVG calculates the average for each value of the group 'category':
    AVG(amount) AS average_price
FROM 
    purchases
-- Instructs SQL that where are doing an aggregation:
GROUP BY 
    category