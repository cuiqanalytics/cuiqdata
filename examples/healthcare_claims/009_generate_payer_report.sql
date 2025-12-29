-- Generate payer report with aggregated claims metrics
CREATE OR REPLACE TABLE payer_report AS
SELECT 
  DATE_TRUNC('day', claim_date) as claim_day,
  claim_status,
  claim_severity,
  value_category,
  plan_type,
  COUNT(*) as claim_count,
  ROUND(SUM(allowed_amount), 2) as total_allowed,
  ROUND(SUM(paid_amount), 2) as total_paid,
  ROUND(SUM(copay), 2) as total_copay,
  ROUND(SUM(coinsurance), 2) as total_coinsurance,
  ROUND(SUM(contractual_adjustment), 2) as total_adjustments,
  ROUND(AVG(allowed_amount), 2) as avg_claim_amount,
  COUNT(DISTINCT patient_id) as unique_patients,
  COUNT(DISTINCT provider_id) as unique_providers
FROM claims_enriched
GROUP BY 
  DATE_TRUNC('day', claim_date),
  claim_status,
  claim_severity,
  value_category,
  plan_type
ORDER BY claim_day DESC, claim_status, claim_severity;
