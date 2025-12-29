-- LEVEL 4 - Step 4: Advanced Time-Series Analysis
--
-- Goal:
--   Go deeper: seasonality, trends, anomalies, forecasting prep.
--   This is where data science meets business analytics.
--
-- Topics:
--   1. Seasonality: Do Sundays always sell more?
--   2. Anomaly Detection: Flag unusual days
--   3. Trend Analysis: Is the trend up, down, or flat?
--   4. Day-of-Week Effects: Which days are strongest?

-- 1. SEASONALITY: Day-of-Week Pattern
CREATE OR REPLACE TABLE day_of_week_analysis AS
SELECT
    DAYNAME(sales_date) AS day_of_week,
    -- DuckDB: MOD gives us 0-6 for Sun-Sat; DAYNAME gives text
    COUNT(*) AS days_recorded,
    ROUND(AVG(daily_revenue), 2) AS avg_revenue,
    ROUND(STDDEV_POP(daily_revenue), 2) AS std_dev,
    MIN(daily_revenue) AS min_revenue,
    MAX(daily_revenue) AS max_revenue
FROM daily_sales
GROUP BY DAYNAME(sales_date)
ORDER BY CASE 
    WHEN DAYNAME(sales_date) = 'Sunday' THEN 1
    WHEN DAYNAME(sales_date) = 'Monday' THEN 2
    WHEN DAYNAME(sales_date) = 'Tuesday' THEN 3
    WHEN DAYNAME(sales_date) = 'Wednesday' THEN 4
    WHEN DAYNAME(sales_date) = 'Thursday' THEN 5
    WHEN DAYNAME(sales_date) = 'Friday' THEN 6
    ELSE 7 -- Saturday
END;

-- SELECT * FROM day_of_week_analysis;

-- 2. ANOMALY DETECTION: Find unusual days
-- Definition: Days where revenue is > 2 standard deviations from mean
CREATE OR REPLACE TABLE anomaly_detection AS
WITH revenue_stats AS (
    SELECT
        AVG(daily_revenue) AS mean_revenue,
        STDDEV_POP(daily_revenue) AS std_dev
    FROM daily_sales
)
SELECT
    ds.sales_date,
    ds.daily_revenue,
    rs.mean_revenue,
    rs.std_dev,
    ROUND((ds.daily_revenue - rs.mean_revenue) / rs.std_dev, 2) AS z_score,
    CASE
        WHEN ABS((ds.daily_revenue - rs.mean_revenue) / rs.std_dev) > 2 THEN 'ANOMALY'
        ELSE 'Normal'
    END AS flag,
    ROUND(100.0 * (ds.daily_revenue - rs.mean_revenue) / rs.mean_revenue, 1) AS pct_from_mean
FROM daily_sales ds, revenue_stats rs
ORDER BY z_score DESC;

-- Show anomalies only
-- SELECT 
--     sales_date,
--     daily_revenue,
--     z_score,
--     pct_from_mean
-- FROM anomaly_detection
-- WHERE flag = 'ANOMALY'
-- ORDER BY sales_date DESC;

-- 3. TREND ANALYSIS: Is revenue trending up or down?
-- Method: Linear regression approximation (change in 30-day average)
CREATE OR REPLACE TABLE trend_analysis AS
WITH moving_avg AS (
    -- Step 1: Calculate 30-day moving average
    SELECT
        sales_date,
        ROUND(
            AVG(daily_revenue) OVER (
                ORDER BY sales_date
                ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
            ), 2
        ) AS ma_30day
    FROM daily_sales
),
trend_calc AS (
    -- Step 2: Compare to prior 30-day average
    SELECT
        sales_date,
        ma_30day,
        LAG(ma_30day) OVER (ORDER BY sales_date) AS prior_ma_30day
    FROM moving_avg
)
SELECT
    sales_date,
    ma_30day,
    CASE
        WHEN ma_30day > prior_ma_30day THEN '↑ Uptrend'
        WHEN ma_30day < prior_ma_30day THEN '↓ Downtrend'
        ELSE '→ Flat'
    END AS trend_direction,
    ROUND(ma_30day - prior_ma_30day, 2) AS ma_change
FROM trend_calc
WHERE prior_ma_30day IS NOT NULL
ORDER BY sales_date DESC
LIMIT 30;

-- 4. COHORT ANALYSIS: Revenue by month
CREATE OR REPLACE TABLE monthly_cohort AS
SELECT
    YEAR(sales_date) AS cohort_year,
    MONTH(sales_date) AS cohort_month,
    CONCAT(
        YEAR(sales_date), '-',
        LPAD(MONTH(sales_date)::VARCHAR, 2, '0')
    ) AS cohort_ym,
    COUNT(*) AS days,
    SUM(daily_revenue)::DECIMAL(12, 2) AS total_revenue,
    ROUND(AVG(daily_revenue), 2) AS avg_daily
FROM daily_sales
GROUP BY YEAR(sales_date), MONTH(sales_date)
ORDER BY cohort_year DESC, cohort_month DESC;

-- SELECT * FROM monthly_cohort;

-- 5. FORECAST PREP: Last 30 days summary for forecasting
CREATE OR REPLACE TABLE forecast_input AS
SELECT
    sales_date,
    daily_revenue,
    revenue_7day_moving_avg,
    DAYNAME(sales_date) AS day_of_week
FROM sales_with_rolling_metrics
WHERE sales_date >= CURRENT_DATE - INTERVAL 30 DAY
ORDER BY sales_date DESC;

-- SELECT * FROM forecast_input;
