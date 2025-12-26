/*
 * LEVEL 1 - Challenge Exercise
 * 
 * Test your understanding of the concepts you just learned.
 * Try to solve these queries WITHOUT looking at the solutions below.
 */

-- CHALLENGE 1: Customer Segmentation
-- Create a table with each customer and their total spending.
-- Include: customer_name, total_spent, order_count
-- Sort by total_spent descending.
-- Hint: GROUP BY customer_name, use SUM(), COUNT()

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE customer_segment AS
-- SELECT ...


-- CHALLENGE 2: Date Analysis
-- Create a table showing daily revenue totals.
-- Include: order_date, daily_total_revenue, daily_order_count
-- Sort by order_date ascending.
-- Hint: GROUP BY order_date

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE daily_revenue AS
-- SELECT ...


-- CHALLENGE 3: City Performance Bands
-- Categorize cities into "High", "Medium", "Low" performers based on revenue.
-- Hint: Use a CASE statement or window functions to rank cities.
-- Include: city, total_revenue, performance_band

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE city_performance_bands AS
-- SELECT ...


-- CHALLENGE 4: YoY Growth (if you have multi-year data)
-- Compare revenue by month across years.
-- Hint: Extract year() and month() from order_date

-- YOUR QUERY HERE:
-- WITH monthly_sales AS (
--   SELECT ...
-- )
-- SELECT ...


/*
 * SOLUTIONS BELOW (Don't peek until you've tried!)
 */

-- ============ SOLUTION 1 ============
-- CREATE OR REPLACE TABLE customer_segment AS
-- SELECT
--     customer_name,
--     SUM(sales_amount) AS total_spent,
--     COUNT(DISTINCT order_id) AS order_count
-- FROM cleaned_orders
-- GROUP BY customer_name
-- ORDER BY total_spent DESC;


-- ============ SOLUTION 2 ============
-- CREATE OR REPLACE TABLE daily_revenue AS
-- SELECT
--     order_date,
--     SUM(sales_amount) AS daily_total_revenue,
--     COUNT(DISTINCT order_id) AS daily_order_count
-- FROM cleaned_orders
-- GROUP BY order_date
-- ORDER BY order_date ASC;


-- ============ SOLUTION 3 ============
-- CREATE OR REPLACE TABLE city_performance_bands AS
-- WITH ranked_cities AS (
--     SELECT
--         city,
--         SUM(sales_amount) AS total_revenue,
--         ROW_NUMBER() OVER (ORDER BY SUM(sales_amount) DESC) AS revenue_rank
--     FROM cleaned_orders
--     GROUP BY city
-- )
-- SELECT
--     city,
--     total_revenue,
--     CASE
--         WHEN revenue_rank <= 3 THEN 'High'
--         WHEN revenue_rank <= 6 THEN 'Medium'
--         ELSE 'Low'
--     END AS performance_band
-- FROM ranked_cities
-- ORDER BY revenue_rank;


-- ============ SOLUTION 4 ============
-- WITH monthly_sales AS (
--     SELECT
--         YEAR(order_date) AS sales_year,
--         MONTH(order_date) AS sales_month,
--         SUM(sales_amount) AS monthly_revenue
--     FROM cleaned_orders
--     GROUP BY YEAR(order_date), MONTH(order_date)
-- )
-- SELECT
--     sales_year,
--     sales_month,
--     monthly_revenue
-- FROM monthly_sales
-- ORDER BY sales_year, sales_month;
