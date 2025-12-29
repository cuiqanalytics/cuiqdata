-- Standardize warehouse master data
CREATE TABLE warehouses_cleaned AS
SELECT 
  UPPER(TRIM(warehouse_id)) as warehouse_id,
  UPPER(TRIM(warehouse_name)) as warehouse_name,
  UPPER(TRIM(region)) as region,
  UPPER(TRIM(country)) as country,
  CAST(max_capacity_units AS INTEGER) as max_capacity_units,
  ROUND(CAST(current_utilization_pct AS DECIMAL(5,2)), 2) as current_utilization_pct,
  LOWER(TRIM(warehouse_status)) as warehouse_status
FROM raw_warehouses
WHERE warehouse_id IS NOT NULL;
