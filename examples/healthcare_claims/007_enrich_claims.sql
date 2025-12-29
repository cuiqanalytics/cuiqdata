-- Enrich claims with patient data, compute financial metrics and compliance flags
CREATE OR REPLACE TABLE claims_enriched AS
SELECT 
  c.claim_id,
  c.patient_id,
  c.member_id,
  c.provider_id,
  c.claim_date,
  c.service_date,
  DATE_DIFF('day', c.service_date, c.claim_date) as days_to_claim,
  c.claim_type,
  c.amount_billed,
  c.allowed_amount,
  ROUND(c.amount_billed - c.allowed_amount, 2) as contractual_adjustment,
  c.copay,
  c.coinsurance,
  c.patient_responsibility,
  c.paid_amount,
  ROUND(c.allowed_amount - c.paid_amount - c.copay - c.coinsurance, 2) as plan_payment_gap,
  CASE 
    WHEN c.claim_type IN ('office_visit', 'lab_test', 'imaging', 'physical_therapy') THEN 'routine'
    WHEN c.claim_type IN ('emergency', 'inpatient', 'surgery') THEN 'urgent'
    WHEN c.claim_type IN ('prescription', 'drug_refund') THEN 'pharmacy'
    ELSE 'other'
  END as claim_severity,
  CASE 
    WHEN c.allowed_amount > 5000 THEN 'high_value'
    WHEN c.allowed_amount > 1000 THEN 'medium_value'
    ELSE 'low_value'
  END as value_category,
  c.denial_reason,
  c.claim_status,
  p.patient_name,
  p.age,
  p.plan_type,
  p.network_status,
  c.processed_at
FROM claims_cleaned c
LEFT JOIN patients_cleaned p ON c.patient_id = p.patient_id;
