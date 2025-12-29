-- Load CSV file directly into DuckDB
-- No TOML config needed - pipeline name will be auto-detected as "simple_csv_processing"
CREATE OR REPLACE TABLE raw_data AS
SELECT * FROM read_csv_auto('./data/input.csv');
