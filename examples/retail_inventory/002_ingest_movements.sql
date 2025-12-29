-- Load inventory movements (sales, transfers, replenishment, damage)
CREATE TABLE raw_movements AS
SELECT * FROM read_csv_auto('./data/movements.csv');
