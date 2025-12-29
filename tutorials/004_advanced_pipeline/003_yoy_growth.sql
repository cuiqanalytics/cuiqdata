-- LEVEL 4 - Step 3: Year-over-Year Growth Analysis
--
-- Goal:
--   Compare this year's revenue to last year's revenue (same date/month/week).
--   This shows if business is growing year-to-year.
--
-- YoY Growth Formula:
--   ((This Year - Last Year) / Last Year) * 100 = Growth %
--
--   Example:
--   2023-01-15: $3,100  (last year)
--   2024-01-15: $5,200  (this year)
--   Growth: ((5200 - 3100) / 3100) * 100 = 67.7%
--
-- Approaches:
--   1. Self-join on date + 365 days (simple, works for most cases)
--   2. ASOF JOIN (advanced, handles missing data better)
--   3. Separate year aggregates + join (clear, modular)
--
-- We'll use approach #3 (separate aggregates) for clarity.

-- Step 1: Extract year and month from dates
CREATE OR REPLACE TABLE sales_by_period AS
SELECT
    sales_date,
    YEAR(sales_date) AS sales_year,
    MONTH(sales_date) AS sales_month,
    WEEK(sales_date) AS sales_week,
    DAY(sales_date) AS sales_day,
    daily_revenue
FROM daily_sales;

-- Step 2: Aggregate by year and month
CREATE OR REPLACE TABLE monthly_revenue AS
SELECT
    sales_year,
    sales_month,
    SUM(daily_revenue)::DECIMAL(12, 2) AS monthly_revenue,
    COUNT(*) AS days_with_data
FROM sales_by_period
GROUP BY sales_year, sales_month
ORDER BY sales_year, sales_month;

-- Step 3: Join current year to previous year
CREATE OR REPLACE TABLE yoy_comparison AS
SELECT
    curr.sales_year,
    curr.sales_month,
    curr.monthly_revenue AS current_year_revenue,
    prev.monthly_revenue AS prior_year_revenue,
    
    -- Growth calculation: % change from prior year
    CASE 
        WHEN prev.monthly_revenue IS NULL THEN NULL
        ELSE ROUND(
            ((curr.monthly_revenue - prev.monthly_revenue) / prev.monthly_revenue) * 100, 
            2
        )
    END AS yoy_growth_pct,
    
    -- Absolute change in dollars
    CASE
        WHEN prev.monthly_revenue IS NULL THEN NULL
        ELSE curr.monthly_revenue - prev.monthly_revenue
    END AS yoy_growth_dollars,
    
    -- Trend indicator
    CASE
        WHEN prev.monthly_revenue IS NULL THEN 'N/A'
        WHEN curr.monthly_revenue > prev.monthly_revenue THEN '↑ Up'
        WHEN curr.monthly_revenue < prev.monthly_revenue THEN '↓ Down'
        ELSE '→ Flat'
    END AS trend

FROM monthly_revenue curr
LEFT JOIN monthly_revenue prev
    ON curr.sales_year = prev.sales_year + 1
    AND curr.sales_month = prev.sales_month

ORDER BY curr.sales_year DESC, curr.sales_month;

-- Display YoY comparison
-- SELECT * FROM yoy_comparison WHERE prior_year_revenue IS NOT NULL;

-- Summary: What's the average YoY growth?
-- SELECT
--     YEAR(MAKE_DATE(sales_year, sales_month, 1)) AS analysis_year,
--     ROUND(AVG(yoy_growth_pct), 2) AS avg_yoy_growth_pct,
--     COUNT(CASE WHEN yoy_growth_pct > 0 THEN 1 END) AS months_with_growth,
--     COUNT(CASE WHEN yoy_growth_pct < 0 THEN 1 END) AS months_with_decline
-- FROM yoy_comparison
-- WHERE prior_year_revenue IS NOT NULL
-- GROUP BY YEAR(MAKE_DATE(sales_year, sales_month, 1))
-- ORDER BY analysis_year DESC;

-- Bonus: Month-over-Month (MoM) Growth
CREATE OR REPLACE TABLE mom_growth AS
SELECT
    sales_year,
    sales_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY sales_year, sales_month) AS prior_month_revenue,
    CASE
        WHEN LAG(monthly_revenue) OVER (ORDER BY sales_year, sales_month) IS NULL THEN NULL
        ELSE ROUND(
            ((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY sales_year, sales_month)) / 
             LAG(monthly_revenue) OVER (ORDER BY sales_year, sales_month)) * 100,
            2
        )
    END AS mom_growth_pct
FROM monthly_revenue
ORDER BY sales_year, sales_month;

-- SELECT * FROM mom_growth WHERE prior_month_revenue IS NOT NULL LIMIT 20;
