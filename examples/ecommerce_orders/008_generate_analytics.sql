-- Generate order analytics aggregated by date, status, and order tier
-- Provides metrics for BI dashboards and business analytics
CREATE OR REPLACE TABLE order_analytics AS
SELECT 
  DATE_TRUNC('day', order_date) as order_date,
  status as order_status,
  order_tier,
  COUNT(*) as order_count,
  SUM(item_count) as total_items,
  MIN(total_amount) as min_amount,
  MAX(total_amount) as max_amount,
  ROUND(AVG(total_amount), 2) as avg_amount,
  ROUND(SUM(total_amount), 2) as total_revenue,
  COUNT(DISTINCT customer_id) as unique_customers
FROM orders_enriched
GROUP BY 
  DATE_TRUNC('day', order_date),
  status,
  order_tier
ORDER BY order_date DESC, order_status, order_tier;
