-- Validate claims with multi-condition checks
-- Returns rows that FAIL validation; if empty, all validations pass
SELECT 
  claim_id,
  'missing_patient_id' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE patient_id IS NULL OR TRIM(patient_id) = ''

UNION ALL

SELECT 
  claim_id,
  'missing_member_id' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE claim_status != 'denied' AND (member_id IS NULL OR TRIM(member_id) = '')

UNION ALL

SELECT 
  claim_id,
  'missing_provider_id' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE provider_id IS NULL OR TRIM(provider_id) = ''

UNION ALL

SELECT 
  claim_id,
  'invalid_claim_amount' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE allowed_amount < 0 AND claim_type != 'drug_refund'

UNION ALL

SELECT 
  claim_id,
  'zero_claim_amount' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE allowed_amount = 0 AND claim_status = 'approved'

UNION ALL

SELECT 
  claim_id,
  'service_after_claim_date' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE service_date > claim_date

UNION ALL

SELECT 
  claim_id,
  'copay_greater_than_allowed' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE copay > allowed_amount

UNION ALL

SELECT 
  claim_id,
  'payment_mismatch' as validation_issue,
  allowed_amount
FROM claims_enriched
WHERE ABS((paid_amount + copay + coinsurance) - allowed_amount) > 0.01
  AND claim_status = 'approved'
  AND allowed_amount > 0;
