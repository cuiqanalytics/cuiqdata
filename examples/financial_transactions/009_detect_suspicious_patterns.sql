-- Detect suspicious transaction patterns with risk scoring
CREATE OR REPLACE TABLE suspicious_transactions AS
SELECT 
  transaction_id,
  account_id,
  counterparty_id,
  account_holder,
  counterparty_name,
  transaction_date,
  amount,
  transaction_type,
  CASE 
    WHEN exceeds_monthly_limit THEN 'exceeds_monthly_limit'
    WHEN large_transfer_flag AND counterparty_risk_flag THEN 'large_transfer_high_risk_counterparty'
    WHEN unverified_account AND amount > 50000 THEN 'large_transaction_unverified_account'
    WHEN counterparty_risk_flag THEN 'high_risk_counterparty'
    WHEN counterparty_country != account_country 
         AND transaction_type IN ('transfer_out', 'payment')
         AND jurisdiction_risk = 'high_risk' THEN 'high_risk_international_transfer'
    WHEN status IN ('flagged', 'pending_review') THEN 'flagged_by_system'
    ELSE 'routine'
  END as suspicious_pattern,
  CASE 
    WHEN exceeds_monthly_limit THEN 10
    WHEN large_transfer_flag AND counterparty_risk_flag THEN 85
    WHEN unverified_account AND amount > 50000 THEN 70
    WHEN counterparty_risk_flag THEN 60
    WHEN jurisdiction_risk = 'high_risk' THEN 50
    WHEN status IN ('flagged', 'pending_review') THEN 40
    ELSE 0
  END as risk_score,
  status,
  processed_at
FROM transactions_enriched
WHERE (
  exceeds_monthly_limit
  OR (large_transfer_flag AND counterparty_risk_flag)
  OR (unverified_account AND amount > 50000)
  OR counterparty_risk_flag
  OR status IN ('flagged', 'pending_review')
)
ORDER BY risk_score DESC, transaction_date DESC;
