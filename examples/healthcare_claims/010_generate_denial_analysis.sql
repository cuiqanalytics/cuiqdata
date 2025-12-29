-- Generate denial analysis report for manual review and appeals
CREATE OR REPLACE TABLE denial_analysis AS
SELECT 
  claim_id,
  patient_id,
  patient_name,
  member_id,
  provider_id,
  claim_date,
  service_date,
  claim_type,
  allowed_amount,
  denial_reason,
  claim_status,
  CASE 
    WHEN denial_reason LIKE '%missing%' THEN 'missing_documentation'
    WHEN denial_reason LIKE '%invalid%' THEN 'invalid_data'
    WHEN denial_reason LIKE '%zero%' THEN 'zero_value'
    WHEN denial_reason = '' OR denial_reason IS NULL THEN 'not_denied'
    ELSE 'other'
  END as denial_category,
  age,
  plan_type,
  network_status
FROM claims_enriched
WHERE claim_status IN ('denied', 'pending_review')
ORDER BY claim_date DESC, allowed_amount DESC;
