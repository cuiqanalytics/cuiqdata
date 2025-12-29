-- LEVEL 2 - Step 2: Clean and Cast Data
-- 
-- Goal:
--   Transform raw data into the 'silver' layer. This is where we:
--   1. Rename columns to snake_case for consistency and ease of querying
--   2. Cast columns to proper data types (DATE, DECIMAL, etc.)
--   3. Handle missing values with COALESCE
--   4. Normalize strings (trim whitespace, lowercase for grouping)
-- 
-- Why This Matters:
--   - Column names with spaces require quotes ("Order Date") everywhere.
--     That's annoying and error-prone. Fix it now.
--   - Type mismatches will cause errors later. Better to catch them here.
--   - Missing values in metrics lead to silent bugs. Use COALESCE to provide
--     sensible defaults (0 for counts/sums, NULL otherwise is acceptable).
--   - Consistent casing prevents "New York" and "new york" from being
--     treated as different cities.
-- 
-- ISO 8601 Dates:
--   The date format '01/15/2024' is ambiguous (US vs. other countries).
--   ISO 8601 (YYYY-MM-DD) is unambiguous and sortable as a string.
--   Always convert to DATE type and display as ISO 8601.

CREATE OR REPLACE TABLE cleaned_orders AS
SELECT
    -- Cast order ID to integer for proper math operations
    "Order ID"::INTEGER AS order_id,
    
    -- Trim whitespace and keep customer name as-is
    TRIM("Customer Name") AS customer_name,
    
    -- Convert text date (MM/DD/YYYY) to proper DATE type
    -- strptime() parses the text, CAST stores it as DATE
    CAST(strptime("Order Date", '%m/%d/%Y') AS DATE) AS order_date,
    
    -- Handle missing sales amounts (NULL) by using 0
    -- Then cast to DECIMAL for proper financial math
    COALESCE("Sales Amount"::DECIMAL(10, 2),0.0) AS sales_amount,
    
    -- Normalize city names: trim whitespace, convert to lowercase
    -- This prevents "New York", "NEW YORK", and " new york" from being separate groups
    LOWER(TRIM("City")) AS city

FROM raw_orders;

-- Inspect the cleaned data
-- Are there any surprising NULLs?
-- Do dates look reasonable?
-- SELECT 
--     COUNT(*) as total_rows,
--     COUNT(DISTINCT order_id) as unique_orders,
--     COUNT(DISTINCT city) as unique_cities,
--     MIN(order_date) as earliest_order,
--     MAX(order_date) as latest_order,
--     SUM(sales_amount) as total_sales
-- FROM cleaned_orders;

-- Check for any remaining suspicious values
-- SELECT * FROM cleaned_orders LIMIT 10;
