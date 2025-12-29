-- Clean and normalize inventory data
CREATE TABLE inventory_cleaned AS
SELECT 
  UPPER(TRIM(sku)) as sku,
  UPPER(TRIM(product_name)) as product_name,
  UPPER(TRIM(warehouse_id)) as warehouse_id,
  CAST(quantity_on_hand AS INTEGER) as quantity_on_hand,
  CAST(COALESCE(quantity_reserved, 0) AS INTEGER) as quantity_reserved,
  CAST(COALESCE(quantity_damaged, 0) AS INTEGER) as quantity_damaged,
  CAST(reorder_point AS INTEGER) as reorder_point,
  CAST(lead_time_days AS INTEGER) as lead_time_days,
  ROUND(CAST(unit_cost AS DECIMAL(10,2)), 2) as unit_cost,
  ROUND(CAST(retail_price AS DECIMAL(10,2)), 2) as retail_price,
  DATE(last_received_date) as last_received_date,
  DATE(last_counted_date) as last_counted_date,
  COALESCE(CAST(quantity_on_hand AS INTEGER), 0) - COALESCE(CAST(quantity_reserved, 0) AS INTEGER) as available_quantity,
  CURRENT_TIMESTAMP as processed_at
FROM raw_inventory
WHERE sku IS NOT NULL
  AND warehouse_id IS NOT NULL;
