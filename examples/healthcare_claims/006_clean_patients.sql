-- Clean and normalize patient demographics, compute age
CREATE OR REPLACE TABLE patients_cleaned AS
SELECT 
  UPPER(TRIM(patient_id)) as patient_id,
  UPPER(TRIM(patient_name)) as patient_name,
  DATE(dob) as dob,
  UPPER(TRIM(gender)) as gender,
  UPPER(TRIM(plan_type)) as plan_type,
  LOWER(TRIM(network_status)) as network_status,
  YEAR(CURRENT_DATE) - YEAR(DATE(dob)) as age
FROM raw_patients
WHERE patient_id IS NOT NULL
  AND dob IS NOT NULL;
