-- Enrich transactions with account and counterparty data and compliance flags
CREATE OR REPLACE TABLE transactions_enriched AS
SELECT 
  t.transaction_id,
  t.account_id,
  t.counterparty_id,
  t.transaction_date,
  t.transaction_timestamp,
  t.transaction_type,
  t.amount,
  t.currency,
  t.description,
  t.merchant_category,
  t.merchant_name,
  t.status,
  t.signed_amount,
  a.account_holder,
  a.account_type,
  a.country as account_country,
  a.jurisdiction,
  a.aml_status,
  a.kyc_status,
  a.account_balance,
  a.monthly_volume_limit,
  a.account_age_years,
  cp.counterparty_name,
  cp.entity_type,
  cp.country as counterparty_country,
  cp.aml_status as cp_aml_status,
  cp.sanctions_list,
  cp.jurisdiction_risk,
  CASE 
    WHEN t.amount >= a.monthly_volume_limit THEN TRUE
    ELSE FALSE
  END as exceeds_monthly_limit,
  CASE 
    WHEN t.transaction_type IN ('transfer_out', 'payment') 
         AND a.account_type = 'checking'
         AND t.amount > 100000 THEN TRUE
    ELSE FALSE
  END as large_transfer_flag,
  CASE 
    WHEN LOWER(TRIM(a.kyc_status)) != 'approved' THEN TRUE
    ELSE FALSE
  END as unverified_account,
  CASE 
    WHEN cp.sanctions_list IN ('match_found', 'flagged') THEN TRUE
    WHEN cp.aml_status IN ('flagged', 'pending_review') THEN TRUE
    ELSE FALSE
  END as counterparty_risk_flag,
  t.processed_at
FROM transactions_cleaned t
LEFT JOIN accounts_cleaned a ON t.account_id = a.account_id
LEFT JOIN counterparties_cleaned cp ON t.counterparty_id = cp.counterparty_id;
