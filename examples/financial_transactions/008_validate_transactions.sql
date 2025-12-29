-- Validate transactions with multi-condition KYC/AML checks
-- Returns rows that FAIL validation; if empty, all validations pass
SELECT 
  transaction_id,
  'missing_account_id' as validation_issue,
  amount
FROM transactions_enriched
WHERE account_id IS NULL OR TRIM(account_id) = ''

UNION ALL

SELECT 
  transaction_id,
  'missing_counterparty_id' as validation_issue,
  amount
FROM transactions_enriched
WHERE counterparty_id IS NULL OR TRIM(counterparty_id) = ''

UNION ALL

SELECT 
  transaction_id,
  'zero_amount' as validation_issue,
  amount
FROM transactions_enriched
WHERE amount = 0

UNION ALL

SELECT 
  transaction_id,
  'unverified_account' as validation_issue,
  amount
FROM transactions_enriched
WHERE kyc_status IS NULL OR LOWER(TRIM(kyc_status)) NOT IN ('approved', 'verified')

UNION ALL

SELECT 
  transaction_id,
  'high_risk_counterparty' as validation_issue,
  amount
FROM transactions_enriched
WHERE counterparty_risk_flag = TRUE

UNION ALL

SELECT 
  transaction_id,
  'counterparty_on_sanctions_list' as validation_issue,
  amount
FROM transactions_enriched
WHERE sanctions_list IN ('match_found', 'flagged', 'unknown')

UNION ALL

SELECT 
  transaction_id,
  'cross_border_transfer_risk' as validation_issue,
  amount
FROM transactions_enriched
WHERE account_country != counterparty_country
  AND transaction_type IN ('transfer_out', 'payment')
  AND jurisdiction_risk IN ('high_risk', 'medium_risk');
