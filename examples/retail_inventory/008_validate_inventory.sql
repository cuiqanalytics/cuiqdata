-- Validate inventory data with multi-condition checks
-- Returns rows that FAIL validation; if empty, all validations pass
CREATE TABLE validation_failures AS
SELECT 
  sku,
  warehouse_id,
  'missing_product_name' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE product_name IS NULL OR TRIM(product_name) = ''

UNION ALL

SELECT 
  sku,
  warehouse_id,
  'invalid_unit_cost' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE unit_cost < 0

UNION ALL

SELECT 
  sku,
  warehouse_id,
  'invalid_retail_price' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE retail_price <= 0

UNION ALL

SELECT 
  sku,
  warehouse_id,
  'negative_quantity_on_hand' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE quantity_on_hand < 0

UNION ALL

SELECT 
  sku,
  warehouse_id,
  'quantity_damaged_exceeds_on_hand' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE quantity_damaged > quantity_on_hand

UNION ALL

SELECT 
  sku,
  warehouse_id,
  'missing_reorder_point' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE reorder_point IS NULL

UNION ALL

SELECT 
  sku,
  warehouse_id,
  'inventory_count_overdue' as validation_issue,
  quantity_on_hand
FROM inventory_enriched
WHERE count_status = 'overdue';
