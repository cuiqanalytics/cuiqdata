-- LESSON 2 - Step 1: Loading Excel data
-- 
-- In DuckDB, you can load data from Excel files using the EXCEL extension, like this:
-- 
-- INSTALL EXCEL;
-- LOAD EXCEL;

INSTALL EXCEL;
LOAD EXCEL;
CREATE OR REPLACE TABLE purchases AS
SELECT * FROM './purchases.xlsx';