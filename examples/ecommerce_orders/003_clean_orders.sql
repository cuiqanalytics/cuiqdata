-- Clean and normalize order data
-- Standardize case, trim whitespace, cast types, and filter valid records
CREATE OR REPLACE TABLE orders_cleaned AS
SELECT 
  order_id,
  customer_id,
  LOWER(TRIM(customer_email)) as customer_email,
  DATE(order_date) as order_date,
  ROUND(total_amount, 2) as total_amount,
  item_count,
  LOWER(TRIM(status)) as status,
  TRIM(shipping_address) as shipping_address,
  LOWER(TRIM(payment_method)) as payment_method,
  TRIM(notes) as notes,
  CURRENT_TIMESTAMP as processed_at
FROM raw_orders
WHERE status IN ('completed', 'pending', 'refunded', 'failed')
  AND order_id IS NOT NULL;
