-- Simple transformation: uppercase names and calculate age
CREATE OR REPLACE TABLE processed_data AS
SELECT
  UPPER(name) as name,
  EXTRACT(YEAR FROM CURRENT_DATE) - CAST(birth_year AS INTEGER) as age,
  department,
  salary
FROM raw_data
WHERE salary > 0;
