-- Load current inventory balances by SKU and warehouse
CREATE TABLE raw_inventory AS
SELECT * FROM read_csv_auto('./data/inventory.csv');
