-- Clean and normalize transaction data
-- Calculate signed amounts based on transaction direction
CREATE OR REPLACE TABLE transactions_cleaned AS
SELECT 
  UPPER(TRIM(transaction_id)) as transaction_id,
  UPPER(TRIM(account_id)) as account_id,
  UPPER(TRIM(counterparty_id)) as counterparty_id,
  DATE(transaction_date) as transaction_date,
  CAST(CONCAT(transaction_date, ' ', transaction_time) AS TIMESTAMP) as transaction_timestamp,
  LOWER(TRIM(transaction_type)) as transaction_type,
  ROUND(ABS(CAST(amount AS DECIMAL(15,2))), 2) as amount,
  UPPER(TRIM(currency)) as currency,
  UPPER(TRIM(description)) as description,
  CAST(merchant_category AS VARCHAR) as merchant_category,
  UPPER(TRIM(merchant_name)) as merchant_name,
  LOWER(TRIM(status)) as status,
  CASE 
    WHEN transaction_type IN ('transfer_out', 'withdrawal') THEN -ABS(ROUND(CAST(amount AS DECIMAL(15,2)), 2))
    WHEN transaction_type IN ('transfer_in', 'deposit') THEN ABS(ROUND(CAST(amount AS DECIMAL(15,2)), 2))
    ELSE ROUND(CAST(amount AS DECIMAL(15,2)), 2)
  END as signed_amount,
  CURRENT_TIMESTAMP as processed_at
FROM raw_transactions
WHERE transaction_id IS NOT NULL
  AND transaction_date IS NOT NULL;
