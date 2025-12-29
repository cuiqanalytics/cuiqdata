-- Generate fulfillment report for warehouse operations
-- Creates warehouse-friendly fulfillment instructions for confirmed and pending orders
CREATE OR REPLACE TABLE fulfillment_report AS
SELECT 
  order_id,
  customer_id,
  order_date,
  fulfillment_status,
  shipping_address,
  item_count as items_ordered,
  actual_item_count as items_in_lines,
  total_amount,
  order_tier,
  CONCAT(
    'Order ',
    order_id,
    ' (',
    fulfillment_status,
    ') - ',
    item_count,
    ' items - $',
    CAST(total_amount AS VARCHAR)
  ) as fulfillment_instruction
FROM orders_enriched
WHERE status IN ('completed', 'pending')
ORDER BY order_date DESC, order_tier DESC;
