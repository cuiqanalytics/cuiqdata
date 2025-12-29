-- Generate compliance summary aggregated by date and jurisdiction
CREATE OR REPLACE TABLE compliance_summary AS
SELECT 
  DATE_TRUNC('day', transaction_date) as transaction_day,
  account_country,
  jurisdiction_risk,
  COUNT(*) as transaction_count,
  COUNT(DISTINCT account_id) as unique_accounts,
  COUNT(DISTINCT counterparty_id) as unique_counterparties,
  ROUND(SUM(ABS(amount)), 2) as total_amount,
  COUNT(CASE WHEN exceeds_monthly_limit THEN 1 END) as limit_exceeded_count,
  COUNT(CASE WHEN large_transfer_flag THEN 1 END) as large_transfer_count,
  COUNT(CASE WHEN unverified_account THEN 1 END) as unverified_account_count,
  COUNT(CASE WHEN counterparty_risk_flag THEN 1 END) as risk_counterparty_count,
  COUNT(CASE WHEN status IN ('flagged', 'pending_review') THEN 1 END) as flagged_count,
  ROUND(COUNT(CASE WHEN status IN ('flagged', 'pending_review') THEN 1 END)::NUMERIC 
    / NULLIF(COUNT(*), 0) * 100, 2) as flagged_percentage
FROM transactions_enriched
GROUP BY 
  DATE_TRUNC('day', transaction_date),
  account_country,
  jurisdiction_risk
ORDER BY transaction_day DESC, flagged_count DESC;
