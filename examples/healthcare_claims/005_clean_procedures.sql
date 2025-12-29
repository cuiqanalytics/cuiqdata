-- Clean and normalize procedure codes and charges
CREATE OR REPLACE TABLE procedures_cleaned AS
SELECT 
  UPPER(TRIM(claim_id)) as claim_id,
  UPPER(TRIM(CAST(procedure_code AS VARCHAR))) as procedure_code,
  UPPER(TRIM(procedure_description)) as procedure_description,
  CAST(units AS INTEGER) as units,
  ROUND(provider_charges, 2) as provider_charges,
  ROUND(allowed_amount, 2) as allowed_amount,
  ROUND((allowed_amount / NULLIF(units, 0)), 2) as allowed_per_unit
FROM raw_procedures
WHERE claim_id IS NOT NULL
  AND procedure_code IS NOT NULL;
