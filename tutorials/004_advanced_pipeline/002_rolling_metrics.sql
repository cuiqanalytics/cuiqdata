-- LEVEL 4 - Step 2: Calculate Rolling Metrics
--
-- Goal:
--   Compute moving averages to smooth daily volatility.
--   A 7-day rolling average reveals the underlying trend.
--
-- Rolling Window Syntax:
--   AVG(daily_revenue) OVER (
--       ORDER BY sales_date
--       ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
--   )
--
--   - ORDER BY sales_date: Process dates in chronological order
--   - ROWS BETWEEN 6 PRECEDING AND CURRENT ROW: Include today + 6 prior days = 7 days
--
-- Why 6 PRECEDING?
--   If you want a 7-day window:
--   - Current row: 1 day
--   - Preceding rows: 6 days
--   - Total: 7 days
--
-- Edge Case (First Few Days):
--   Day 1 has no prior days, so the window is smaller.
--   - Day 1: 1-day average (just that day)
--   - Day 2: 2-day average (days 1-2)
--   - Day 7+: 7-day average (full window)
--
--   This is intentional: Ramp up smoothly to the full window.
--   If you want a fixed 7-day window, use ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
--   and ignore the first 6 rows.
--
-- Other Rolling Metrics:
--   - SUM: Total over the window (e.g., 7-day revenue)
--   - MIN/MAX: Lowest/highest in the window
--   - STDDEV: Volatility over the window

CREATE OR REPLACE TABLE sales_with_rolling_metrics AS
SELECT
    sales_date,
    daily_revenue,
    order_count,
    
    -- 7-day rolling average (smooths daily noise)
    ROUND(
        AVG(daily_revenue) OVER (
            ORDER BY sales_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2
    ) AS revenue_7day_moving_avg,
    
    -- 7-day rolling total (useful for weekly reporting)
    SUM(daily_revenue) OVER (
        ORDER BY sales_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS revenue_7day_total,
        
    -- 30-day (monthly) rolling average for longer-term trends
    ROUND(
        AVG(daily_revenue) OVER (
            ORDER BY sales_date
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ), 2
    ) AS revenue_30day_moving_avg,
    
    -- Volatility: How much does daily revenue vary?
    ROUND(
        STDDEV_POP(daily_revenue) OVER (
            ORDER BY sales_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2
    ) AS revenue_7day_volatility

FROM daily_sales
ORDER BY sales_date;

-- Inspect: See the smoothing in action
-- SELECT 
--     sales_date,
--     daily_revenue,
--     revenue_7day_moving_avg,
--     revenue_7day_total,
--     revenue_30day_moving_avg
-- FROM sales_with_rolling_metrics
-- ORDER BY sales_date DESC
-- LIMIT 30;

-- Compare raw vs. smoothed visually (for export to charting tools)
CREATE OR REPLACE TABLE revenue_trends AS
SELECT
    sales_date,
    daily_revenue,
    revenue_7day_moving_avg,
    revenue_30day_moving_avg,
    ROUND(100.0 * (daily_revenue - LAG(daily_revenue) OVER (ORDER BY sales_date)) / 
          LAG(daily_revenue) OVER (ORDER BY sales_date), 1) AS daily_pct_change
FROM sales_with_rolling_metrics
ORDER BY sales_date;

-- SELECT * FROM revenue_trends ORDER BY sales_date DESC LIMIT 20;
