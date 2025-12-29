-- Generate stock health report aggregated by warehouse and status
CREATE TABLE stock_health_report AS
SELECT 
  warehouse_id,
  warehouse_name,
  region,
  stock_status,
  COUNT(*) as sku_count,
  ROUND(SUM(quantity_on_hand), 0) as total_units_on_hand,
  ROUND(SUM(available_quantity), 0) as total_available_units,
  ROUND(SUM(inventory_value_cost), 2) as total_inventory_value_cost,
  ROUND(SUM(inventory_value_retail), 2) as total_inventory_value_retail,
  ROUND(AVG(unit_cost), 2) as avg_unit_cost,
  COUNT(CASE WHEN urgency_flag > 0 THEN 1 END) as urgent_restocking_items,
  COUNT(CASE WHEN count_status = 'overdue' THEN 1 END) as overdue_count_items,
  ROUND(COUNT(CASE WHEN stock_status = 'out_of_stock' THEN 1 END)::NUMERIC / COUNT(*) * 100, 2) as out_of_stock_percentage
FROM inventory_enriched
GROUP BY 
  warehouse_id,
  warehouse_name,
  region,
  stock_status
ORDER BY warehouse_id, stock_status;
