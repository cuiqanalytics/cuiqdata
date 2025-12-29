-- Enrich inventory with warehouse data and compute stock status
CREATE TABLE inventory_enriched AS
SELECT 
  i.sku,
  i.product_name,
  i.warehouse_id,
  i.quantity_on_hand,
  i.quantity_reserved,
  i.quantity_damaged,
  i.available_quantity,
  i.reorder_point,
  i.lead_time_days,
  i.unit_cost,
  i.retail_price,
  ROUND(i.unit_cost * i.quantity_on_hand, 2) as inventory_value_cost,
  ROUND(i.retail_price * i.available_quantity, 2) as inventory_value_retail,
  i.last_received_date,
  i.last_counted_date,
  DATE_DIFF('day', i.last_counted_date, CURRENT_DATE) as days_since_count,
  w.warehouse_name,
  w.region,
  w.max_capacity_units,
  w.current_utilization_pct,
  CASE 
    WHEN i.available_quantity <= 0 THEN 'out_of_stock'
    WHEN i.available_quantity < i.reorder_point THEN 'low_stock'
    WHEN i.available_quantity >= (i.reorder_point * 3) THEN 'overstock'
    ELSE 'normal'
  END as stock_status,
  CASE 
    WHEN i.available_quantity <= 0 THEN 1
    WHEN i.available_quantity < i.reorder_point THEN 0.5
    ELSE 0
  END as urgency_flag,
  CASE 
    WHEN i.days_since_count > 30 THEN 'overdue'
    WHEN i.days_since_count > 14 THEN 'due_soon'
    ELSE 'current'
  END as count_status,
  i.processed_at
FROM inventory_cleaned i
LEFT JOIN warehouses_cleaned w ON i.warehouse_id = w.warehouse_id;
