-- Enrich orders with computed fields and line item aggregations
-- Join orders with aggregated line items, add order tier classification, compute fulfillment status
CREATE OR REPLACE TABLE orders_enriched AS
SELECT 
  o.order_id,
  o.customer_id,
  o.customer_email,
  o.order_date,
  o.total_amount,
  o.item_count,
  o.status,
  CASE 
    WHEN o.status = 'completed' THEN 'confirmed'
    WHEN o.status = 'pending' THEN 'awaiting_payment'
    WHEN o.status = 'failed' THEN 'payment_failed'
    WHEN o.status = 'refunded' THEN 'cancelled'
  END as fulfillment_status,
  o.shipping_address,
  o.payment_method,
  o.notes,
  COALESCE(oi.item_count_in_order, 0) as actual_item_count,
  COALESCE(oi.line_total, 0) as line_items_total,
  CASE 
    WHEN o.total_amount > 0 AND o.total_amount <= 50 THEN 'economy'
    WHEN o.total_amount > 50 AND o.total_amount <= 200 THEN 'standard'
    WHEN o.total_amount > 200 THEN 'premium'
    ELSE 'invalid'
  END as order_tier,
  o.processed_at
FROM orders_cleaned o
LEFT JOIN (
  SELECT 
    order_id,
    COUNT(*) as item_count_in_order,
    SUM(total_price) as line_total
  FROM order_items_cleaned
  GROUP BY order_id
) oi ON o.order_id = oi.order_id;
