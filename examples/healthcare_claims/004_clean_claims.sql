-- Clean and normalize claim data
CREATE OR REPLACE TABLE claims_cleaned AS
SELECT 
  UPPER(TRIM(claim_id)) as claim_id,
  UPPER(TRIM(patient_id)) as patient_id,
  UPPER(TRIM(member_id)) as member_id,
  UPPER(TRIM(provider_id)) as provider_id,
  DATE(claim_date) as claim_date,
  DATE(service_date) as service_date,
  LOWER(TRIM(claim_type)) as claim_type,
  ROUND(amount_billed, 2) as amount_billed,
  ROUND(allowed_amount, 2) as allowed_amount,
  COALESCE(ROUND(CAST(copay AS DECIMAL(10,2)), 2), 0) as copay,
  COALESCE(ROUND(CAST(coinsurance AS DECIMAL(10,2)), 2), 0) as coinsurance,
  COALESCE(ROUND(CAST(patient_responsibility AS DECIMAL(10,2)), 2), 0) as patient_responsibility,
  ROUND(paid_amount, 2) as paid_amount,
  LOWER(TRIM(denial_reason)) as denial_reason,
  LOWER(TRIM(claim_status)) as claim_status,
  CURRENT_TIMESTAMP as processed_at
FROM raw_claims
WHERE claim_id IS NOT NULL
  AND claim_date IS NOT NULL;
