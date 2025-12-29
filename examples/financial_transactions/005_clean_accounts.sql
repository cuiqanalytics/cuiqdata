-- Standardize account metadata
CREATE OR REPLACE TABLE accounts_cleaned AS
SELECT 
  UPPER(TRIM(account_id)) as account_id,
  UPPER(TRIM(account_holder)) as account_holder,
  LOWER(TRIM(account_type)) as account_type,
  DATE(opening_date) as opening_date,
  UPPER(TRIM(country)) as country,
  UPPER(TRIM(jurisdiction)) as jurisdiction,
  LOWER(TRIM(aml_status)) as aml_status,
  LOWER(TRIM(kyc_status)) as kyc_status,
  ROUND(CAST(account_balance AS DECIMAL(15,2)), 2) as account_balance,
  ROUND(CAST(monthly_volume_limit AS DECIMAL(15,2)), 2) as monthly_volume_limit,
  YEAR(CURRENT_DATE) - YEAR(DATE(opening_date)) as account_age_years
FROM raw_accounts
WHERE account_id IS NOT NULL;
