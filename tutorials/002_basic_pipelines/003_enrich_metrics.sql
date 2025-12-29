-- LEVEL 2 - Step 3: Enrich and Calculate Metrics
-- 
-- Goal:
--   Create the 'gold' layer: pre-calculated metrics ready for dashboards
--   and business tools like Excel or Power BI.
-- 
-- Why Pre-Calculate?
--   - Slow transformations are done once, cached here.
--   - Business users can query this table directly without SQL knowledge.
--   - Dashboard tools load faster querying a simple table vs. expensive joins.
-- 
-- What Makes a Good Gold Table:
--   - One question answered per metric (total revenue, average order size, etc.)
--   - Sortable and filterable (include GROUP BY dimensions first)
--   - Simple enough to export to CSV or Parquet for other tools
--   - Includes counts alongside metrics (know the denominator!)
-- 

CREATE OR REPLACE TABLE city_revenue_stats AS
SELECT
    -- Dimension: the city we're analyzing
    city,
    
    -- Metrics: pre-calculated answers to business questions
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales_amount) AS total_revenue,
    ROUND(AVG(sales_amount), 2) AS avg_ticket_size,
    
    -- Additional insights
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date,
    COUNT(DISTINCT customer_name) AS unique_customers

FROM cleaned_orders
GROUP BY city
ORDER BY total_revenue DESC;

-- Preview the results
-- This table should be ready to copy-paste into a PowerPoint slide
-- SELECT * FROM city_revenue_stats;

-- Let's also spot-check one city manually to verify our math
-- Change 'new york' to whichever city you want to verify
/*
SELECT 
    COUNT(DISTINCT order_id) as manual_orders,
    SUM(sales_amount) as manual_revenue,
    ROUND(AVG(sales_amount), 2) as manual_avg
FROM cleaned_orders
WHERE city = 'new york';
*/
