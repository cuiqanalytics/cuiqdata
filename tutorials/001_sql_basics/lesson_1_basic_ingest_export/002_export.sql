-- LESSON 1 - Step 2: Exporting Data
-- 
-- Goal:
--   Learn the basics of exporting data from a table using SQL
-- 
-- In DuckDB, you can export data to multiple formats. In this case we will export to tab delimited file
-- The following `COPY` command achieves this. The general syntax is:
--
--      COPY table_name TO 'file_path' (list of options);
--
-- The (list of options) specifies how the data should be formatted and written to the file.
--
-- For example to output a file as delimited (CSV), with a header, and tabulation as delimiter, here is the command for that:

COPY animal_data TO 'animal_data.txt' (FORMAT CSV, HEADER, DELIMITER '\t');