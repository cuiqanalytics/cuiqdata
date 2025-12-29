-- Analyze movements with product info and financial impact
CREATE TABLE movements_analyzed AS
SELECT 
  m.movement_id,
  m.sku,
  m.warehouse_id,
  m.movement_date,
  m.movement_type,
  m.quantity,
  m.signed_quantity,
  m.reference_id,
  m.reason,
  m.notes,
  i.product_name,
  i.unit_cost,
  i.retail_price,
  ROUND(CAST(m.signed_quantity AS DECIMAL) * i.unit_cost, 2) as movement_cost_impact,
  ROUND(CAST(m.signed_quantity AS DECIMAL) * i.retail_price, 2) as movement_revenue_impact,
  CASE 
    WHEN m.movement_type = 'sale' THEN 'customer'
    WHEN m.movement_type = 'replenishment' THEN 'supplier'
    WHEN m.movement_type = 'transfer' THEN 'internal'
    WHEN m.movement_type IN ('damage', 'inventory_adjustment') THEN 'operational'
    ELSE 'other'
  END as movement_category,
  ROW_NUMBER() OVER (PARTITION BY m.sku, m.warehouse_id ORDER BY m.movement_date DESC) as recency_rank
FROM movements_cleaned m
LEFT JOIN inventory_enriched i ON m.sku = i.sku AND m.warehouse_id = i.warehouse_id;
