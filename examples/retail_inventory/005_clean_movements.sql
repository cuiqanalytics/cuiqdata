-- Clean and normalize movement data
CREATE TABLE movements_cleaned AS
SELECT 
  UPPER(TRIM(movement_id)) as movement_id,
  UPPER(TRIM(sku)) as sku,
  UPPER(TRIM(warehouse_id)) as warehouse_id,
  DATE(movement_date) as movement_date,
  LOWER(TRIM(movement_type)) as movement_type,
  CAST(quantity AS INTEGER) as quantity,
  UPPER(TRIM(reference_id)) as reference_id,
  LOWER(TRIM(reason)) as reason,
  UPPER(TRIM(notes)) as notes,
  CASE 
    WHEN LOWER(TRIM(movement_type)) = 'sale' THEN -ABS(CAST(quantity AS INTEGER))
    WHEN LOWER(TRIM(movement_type)) = 'replenishment' THEN ABS(CAST(quantity AS INTEGER))
    WHEN LOWER(TRIM(movement_type)) = 'transfer' THEN CAST(quantity AS INTEGER)
    WHEN LOWER(TRIM(movement_type)) = 'damage' THEN -ABS(CAST(quantity AS INTEGER))
    WHEN LOWER(TRIM(movement_type)) = 'inventory_adjustment' THEN CAST(quantity AS INTEGER)
    ELSE 0
  END as signed_quantity,
  CURRENT_TIMESTAMP as processed_at
FROM raw_movements
WHERE movement_id IS NOT NULL;
