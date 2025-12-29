-- Load warehouse master data and capacity information
CREATE TABLE raw_warehouses AS
SELECT * FROM read_csv_auto('./data/warehouses.csv');
