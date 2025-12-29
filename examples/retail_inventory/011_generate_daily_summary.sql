-- Generate daily movement summary with cost and revenue impact
CREATE TABLE daily_movement_summary AS
SELECT 
  movement_date,
  warehouse_id,
  movement_type,
  COUNT(*) as movement_count,
  ROUND(SUM(ABS(CAST(quantity AS DECIMAL))), 0) as total_units_moved,
  COUNT(DISTINCT sku) as unique_skus,
  ROUND(SUM(movement_cost_impact), 2) as cost_impact,
  ROUND(SUM(movement_revenue_impact), 2) as revenue_impact,
  CASE 
    WHEN movement_type = 'sale' THEN 'revenue'
    WHEN movement_type = 'replenishment' THEN 'investment'
    WHEN movement_type IN ('damage', 'inventory_adjustment') THEN 'loss'
    WHEN movement_type = 'transfer' THEN 'rebalance'
    ELSE 'other'
  END as impact_type
FROM movements_analyzed
WHERE recency_rank <= 1
  AND movement_type IN ('sale', 'replenishment', 'transfer', 'damage')
GROUP BY 
  movement_date,
  warehouse_id,
  movement_type
ORDER BY movement_date DESC, warehouse_id, movement_type;
