-- Clean and normalize order line items
-- Standardize product names, validate quantities, calculate computed prices
CREATE OR REPLACE TABLE order_items_cleaned AS
SELECT 
  order_id,
  item_id,
  UPPER(TRIM(product_name)) as product_name,
  UPPER(TRIM(sku)) as sku,
  quantity,
  ROUND(unit_price, 2) as unit_price,
  ROUND(discount_pct, 2) as discount_pct,
  ROUND(total_price, 2) as total_price,
  ROUND(unit_price * quantity * (1 - discount_pct/100), 2) as calculated_price
FROM raw_order_items
WHERE order_id IS NOT NULL
  AND item_id IS NOT NULL
  AND quantity > 0;
