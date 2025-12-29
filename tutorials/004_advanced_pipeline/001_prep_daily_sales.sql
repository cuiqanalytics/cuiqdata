-- LEVEL 4 - Step 1: Prepare Daily Sales Data
--
-- Goal:
--   Load daily sales data from CSV and prepare it for time-series analysis.
--   This is the foundation for rolling averages and YoY comparisons.
--
-- Why Start Here?
--   - Rolling windows and YoY joins require consistent daily rows
--   - Missing days reveal gaps in data that need handling
--   - Foundation for all downstream time-series logic
--
-- Data Source:
--   This step loads sample_daily_sales.csv which contains pre-aggregated daily totals.
--   If you completed Level 2, you can swap sample_daily_sales.csv for cleaned_orders
--   and aggregate it yourself (see commented code at the end).

CREATE OR REPLACE TABLE daily_sales AS
SELECT
    CAST(sales_date AS DATE) AS sales_date,
    CAST(daily_revenue AS DECIMAL(12, 2)) AS daily_revenue,
    CAST(order_count AS INTEGER) AS order_count
FROM read_csv_auto('./data/sample_daily_sales.csv');

-- Alternative: If you completed Level 2, uncomment below to use cleaned_orders
-- CREATE OR REPLACE TABLE daily_sales AS
-- SELECT
--     CAST(order_date AS DATE) AS sales_date,
--     SUM(sales_amount)::DECIMAL(12, 2) AS daily_revenue,
--     COUNT(DISTINCT order_id) AS order_count
-- FROM cleaned_orders
-- GROUP BY CAST(order_date AS DATE)
-- ORDER BY sales_date ASC;

-- Inspect: Do we have complete date coverage?
-- (Some days might be missing if there were zero sales)
-- SELECT 
--     MIN(sales_date) AS first_day,
--     MAX(sales_date) AS last_day,
--     COUNT(*) AS days_with_sales,
--     DATEDIFF('day', MIN(sales_date), MAX(sales_date)) + 1 AS calendar_days,
--     ROUND(100.0 * COUNT(*) / (DATEDIFF('day', MIN(sales_date), MAX(sales_date)) + 1), 1) AS coverage_pct
-- FROM daily_sales;

-- Sample data
-- SELECT * FROM daily_sales ORDER BY sales_date DESC LIMIT 10;

-- Basic statistics
-- SELECT 
--     COUNT(*) AS days,
--     ROUND(AVG(daily_revenue), 2) AS avg_daily_revenue,
--     MIN(daily_revenue) AS min_daily_revenue,
--     MAX(daily_revenue) AS max_daily_revenue,
--     STDDEV_POP(daily_revenue) AS std_dev_revenue
-- FROM daily_sales;
