-- LESSON 1 - Step 1: Ingesting Data
-- 
-- Goal:
--   Learn the basics of loading data into a table using SQL
-- 
-- About SQL:
--   SQL is a powerful language for querying and manipulating data.
--   It is used to interact with databases and perform various operations on data.
--   It is "declarative", which means you tell the database what you want, not how to do it.
--   SQL is a standard language, but different databases may have slight variations.
--   The keywords resemble plain English, making it easy to learn and use.
--   Note: Comments (lines starting with --) are ignored by the database and are used for documentation and explanation.
--   Note: The SQL syntax we will use is from a database called DuckDB (www.duckdb.org) 
--
-- SQL Basics:
--   DDL (Data Definition Language) is a subset of SQL keywords to create, modify, and delete database objects.
--   For example, to create a table the general syntax is:
--
--      CREATE OR REPLACE TABLE table_name (
--          column1_name column1_type,
--          column2_name column2_type,
--          ...
--      );
-- 
--   To query a table you use a SELECT statement like this:
--
--      SELECT column1, column2, ... FROM table_name
--
--   Tip: You can combine CREATE OR REPLACE TABLE with SELECT to create a table from a query
--
-- For example, the following command will create (or replace if it already exists) a table named animal_data
-- and load the data coming from 'animals.csv' file:

CREATE OR REPLACE TABLE animal_data AS
SELECT * FROM read_csv_auto('./animals.csv');

-- The `read_csv_auto` function is a convenient way to automatically detect the data types of the columns.