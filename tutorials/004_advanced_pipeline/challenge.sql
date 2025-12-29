/*
 * LEVEL 3 - Challenge Exercises
 * 
 * These challenges test your mastery of time-series analysis.
 * They integrate concepts from all three levels.
 */

-- CHALLENGE 1: Weekly Revenue Summary
-- Create a table showing:
--   - Week number, week start date, week end date
--   - Weekly revenue, weekly orders
--   - Week-over-Week growth %
-- Hint: GROUP BY WEEK(sales_date), use LAG()

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE weekly_performance AS
-- SELECT ...


-- CHALLENGE 2: Best and Worst Days
-- For each month, identify the best and worst performing day.
-- Include: month, best_date, best_revenue, worst_date, worst_revenue
-- Hint: Use ROW_NUMBER() OVER (PARTITION BY MONTH ... ORDER BY daily_revenue)

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE best_worst_days AS
-- SELECT ...


-- CHALLENGE 3: Seasonal Decomposition
-- Break down daily revenue into:
--   - Trend (30-day moving average)
--   - Day-of-week effect (avg revenue by day of week - overall avg)
--   - Remainder (actual - trend - day-of-week effect)
-- Hint: Calculate overall_avg, dow_avg, then remainder

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE seasonal_decomposition AS
-- SELECT ...


-- CHALLENGE 4: Cohort Retention (if using customer data)
-- Track revenue per customer cohort over time.
-- Cohort = month when customer first purchased
-- Show: cohort_month, months_since, returning_customer_revenue
-- Hint: Use first_purchase_month and datediff()

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE cohort_retention AS
-- SELECT ...


-- CHALLENGE 5: Forecast Baseline
-- Create a simple forecast for next 7 days using:
--   - 30-day moving average as baseline
--   - Day-of-week adjustment
-- Hint: Multiply MA_30 by (dow_avg / overall_avg)

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE forecast_7day AS
-- SELECT ...


/*
 * SOLUTIONS BELOW (Don't peek until you've tried!)
 */

-- ============ SOLUTION 1 ============
-- CREATE OR REPLACE TABLE weekly_performance AS
-- WITH weekly_totals AS (
--     SELECT
--         WEEK(sales_date) AS week_num,
--         YEAR(sales_date) AS sales_year,
--         MIN(sales_date) AS week_start,
--         MAX(sales_date) AS week_end,
--         SUM(daily_revenue) AS weekly_revenue,
--         SUM(daily_orders) AS weekly_orders
--     FROM daily_sales
--     GROUP BY WEEK(sales_date), YEAR(sales_date)
-- )
-- SELECT
--     sales_year,
--     week_num,
--     week_start,
--     week_end,
--     weekly_revenue,
--     weekly_orders,
--     LAG(weekly_revenue) OVER (ORDER BY sales_year, week_num) AS prior_week_revenue,
--     CASE
--         WHEN LAG(weekly_revenue) OVER (ORDER BY sales_year, week_num) IS NOT NULL
--         THEN ROUND(((weekly_revenue - LAG(weekly_revenue) OVER (ORDER BY sales_year, week_num)) / 
--                      LAG(weekly_revenue) OVER (ORDER BY sales_year, week_num)) * 100, 2)
--         ELSE NULL
--     END AS wow_growth_pct
-- FROM weekly_totals
-- ORDER BY sales_year, week_num;


-- ============ SOLUTION 2 ============
-- CREATE OR REPLACE TABLE best_worst_days AS
-- WITH ranked_days AS (
--     SELECT
--         YEAR(sales_date) AS sales_year,
--         MONTH(sales_date) AS sales_month,
--         sales_date,
--         daily_revenue,
--         ROW_NUMBER() OVER (PARTITION BY MONTH(sales_date), YEAR(sales_date) 
--                            ORDER BY daily_revenue DESC) AS rank_best,
--         ROW_NUMBER() OVER (PARTITION BY MONTH(sales_date), YEAR(sales_date) 
--                            ORDER BY daily_revenue ASC) AS rank_worst
--     FROM daily_sales
-- )
-- SELECT
--     sales_year,
--     sales_month,
--     MAX(CASE WHEN rank_best = 1 THEN sales_date END) AS best_date,
--     MAX(CASE WHEN rank_best = 1 THEN daily_revenue END) AS best_revenue,
--     MAX(CASE WHEN rank_worst = 1 THEN sales_date END) AS worst_date,
--     MAX(CASE WHEN rank_worst = 1 THEN daily_revenue END) AS worst_revenue
-- FROM ranked_days
-- GROUP BY sales_year, sales_month
-- ORDER BY sales_year DESC, sales_month DESC;


-- ============ SOLUTION 3 ============
-- CREATE OR REPLACE TABLE seasonal_decomposition AS
-- WITH with_trend AS (
--     SELECT
--         sales_date,
--         daily_revenue,
--         ROUND(
--             AVG(daily_revenue) OVER (
--                 ORDER BY sales_date
--                 ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
--             ), 2
--         ) AS trend_30day
--     FROM daily_sales
-- ),
-- with_dow AS (
--     SELECT
--         wt.*,
--         DAYNAME(wt.sales_date) AS day_of_week,
--         ROUND(AVG(wt.daily_revenue) OVER (PARTITION BY DAYNAME(wt.sales_date)), 2) AS dow_avg,
--         ROUND(AVG(wt.daily_revenue) OVER (), 2) AS overall_avg
--     FROM with_trend wt
-- )
-- SELECT
--     sales_date,
--     daily_revenue,
--     trend_30day,
--     ROUND(dow_avg - overall_avg, 2) AS day_of_week_effect,
--     ROUND(daily_revenue - trend_30day - (dow_avg - overall_avg), 2) AS remainder,
--     day_of_week
-- FROM with_dow
-- ORDER BY sales_date;


-- ============ SOLUTION 4 (Optional - requires customer data) ============
-- This assumes a transactions table with customer_id and order_date
-- CREATE OR REPLACE TABLE cohort_retention AS
-- WITH customer_cohorts AS (
--     SELECT
--         customer_id,
--         YEAR(MIN(order_date)) || '-' || LPAD(MONTH(MIN(order_date))::VARCHAR, 2, '0') AS cohort_month,
--         YEAR(order_date) || '-' || LPAD(MONTH(order_date)::VARCHAR, 2, '0') AS activity_month,
--         SUM(sales_amount) AS monthly_revenue
--     FROM cleaned_orders
--     GROUP BY customer_id, YEAR(order_date), MONTH(order_date)
-- )
-- SELECT
--     cohort_month,
--     activity_month,
--     COUNT(DISTINCT customer_id) AS cohort_size,
--     SUM(monthly_revenue)::DECIMAL(12, 2) AS total_revenue
-- FROM customer_cohorts
-- GROUP BY cohort_month, activity_month
-- ORDER BY cohort_month, activity_month;


-- ============ SOLUTION 5 ============
-- CREATE OR REPLACE TABLE forecast_7day AS
-- WITH dow_patterns AS (
--     SELECT
--         DAYNAME(sales_date) AS day_of_week,
--         ROUND(AVG(daily_revenue), 2) AS avg_revenue_by_dow,
--         ROUND(AVG(AVG(daily_revenue)) OVER (), 2) AS overall_avg
--     FROM daily_sales
--     GROUP BY DAYNAME(sales_date)
-- ),
-- recent_ma AS (
--     SELECT
--         MAX(ROUND(AVG(daily_revenue) OVER (
--             ORDER BY sales_date
--             ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
--         ), 2)) AS latest_ma_30
--     FROM daily_sales
-- )
-- SELECT
--     CURRENT_DATE + INTERVAL (row_number() - 1) DAY AS forecast_date,
--     DAYNAME(CURRENT_DATE + INTERVAL (row_number() - 1) DAY) AS forecast_day,
--     ROUND(
--         (SELECT latest_ma_30 FROM recent_ma) * 
--         (dp.avg_revenue_by_dow / dp.overall_avg),
--         2
--     ) AS forecasted_revenue
-- FROM (SELECT GENERATE_SUBSCRIPTS(ARRAY[1, 2, 3, 4, 5, 6, 7], 1) AS row_number) s
-- CROSS JOIN dow_patterns dp
-- WHERE DAYNAME(CURRENT_DATE + INTERVAL (s.row_number - 1) DAY) = dp.day_of_week;
