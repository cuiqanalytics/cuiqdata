-- Standardize counterparty data with jurisdiction risk classification
CREATE OR REPLACE TABLE counterparties_cleaned AS
SELECT 
  UPPER(TRIM(counterparty_id)) as counterparty_id,
  UPPER(TRIM(counterparty_name)) as counterparty_name,
  LOWER(TRIM(entity_type)) as entity_type,
  UPPER(TRIM(country)) as country,
  LOWER(TRIM(aml_status)) as aml_status,
  LOWER(TRIM(sanctions_list)) as sanctions_list,
  UPPER(TRIM(notes)) as notes,
  CASE 
    WHEN LOWER(TRIM(country)) IN ('PANAMA', 'HONG_KONG', 'DUBAI', 'UNKNOWN') THEN 'high_risk'
    WHEN LOWER(TRIM(country)) IN ('USA', 'CANADA', 'UK') THEN 'low_risk'
    ELSE 'medium_risk'
  END as jurisdiction_risk
FROM raw_counterparties
WHERE counterparty_id IS NOT NULL;
