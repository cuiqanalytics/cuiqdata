-- Validate data quality with multi-condition checks
-- Returns rows that FAIL validation; if empty, all validations pass
SELECT 
  order_id,
  'missing_customer_id' as validation_issue,
  total_amount
FROM orders_enriched
WHERE customer_id IS NULL OR customer_id = ''

UNION ALL

SELECT 
  order_id,
  'missing_email' as validation_issue,
  total_amount
FROM orders_enriched
WHERE customer_email IS NULL OR customer_email = ''

UNION ALL

SELECT 
  order_id,
  'negative_total_amount' as validation_issue,
  total_amount
FROM orders_enriched
WHERE total_amount < 0 AND status != 'refunded'

UNION ALL

SELECT 
  order_id,
  'amount_mismatch' as validation_issue,
  total_amount
FROM orders_enriched
WHERE ABS(total_amount - COALESCE(line_items_total, 0)) > 0.01
  AND status = 'completed'

UNION ALL

SELECT 
  order_id,
  'missing_shipping_address' as validation_issue,
  total_amount
FROM orders_enriched
WHERE status = 'completed' 
  AND (shipping_address IS NULL OR shipping_address = '');
