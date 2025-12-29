# Level 1: SQL Basics

## Overview

In this tutorial, you'll master the fundamentals of loading, transforming, and exporting data using SQL. You'll work through three practical lessons that build on each other, starting with simple CSV files and progressing to Excel data and validation techniques.

## Prerequisites

- cuiqData installed and working (`cuiqdata --version` should show a version number)
- Basic terminal/command line skills (see TERMINAL_BASICS.md in the parent directory)
- No prior SQL experience needed—this tutorial teaches you from the ground up

## Learning Goals

- Load data from CSV and Excel files using `read_csv_auto()` and `read_excel()`
- Understand automatic type detection
- Master basic SELECT queries with WHERE, ORDER BY, and GROUP BY
- Export data to multiple formats (CSV, TSV, Excel)
- Validate data quality with row counts, null checks, and filtering
- Build confidence with foundational SQL patterns

## Lessons Included

### Lesson 1: Ingest & Export Delimited Files (CSV)

Learn the fundamentals of loading and exporting CSV data using automatic type detection.

**What you'll learn:**
- `read_csv_auto()` for loading CSV files with automatic type inference
- `CREATE OR REPLACE TABLE` for idempotent table creation
- `COPY` statement for exporting to different delimited formats
- Basic SELECT queries

**Time:** 15 minutes

**Files:**
- `lesson_1_basic_ingest_export/001_ingest.sql` - Load CSV data
- `lesson_1_basic_ingest_export/002_export.sql` - Export to tab-delimited format
- `lesson_1_basic_ingest_export/animals.csv` - Sample dataset

---

### Lesson 2: Working with Excel Files

Load, aggregate, and export Excel data. Learn how to work with structured tabular data from office tools.

**What you'll learn:**
- `read_excel()` for loading Excel files
- Basic aggregation with `GROUP BY` and `SUM()`
- Filtering with WHERE clauses
- Exporting to multiple formats including Excel

**Time:** 20 minutes

**Files:**
- `lesson_2_working_with_excel_files/001_ingest.sql` - Load Excel file
- `lesson_2_working_with_excel_files/002_aggregate.sql` - Create summary metrics
- `lesson_2_working_with_excel_files/003_export_excel.sql` - Export to Excel format
- `lesson_2_working_with_excel_files/purchases.xlsx` - Sample dataset

---

### Lesson 3: Data Validation

Ensure data quality by validating row counts, checking for nulls, and cleaning inconsistent values.

**What you'll learn:**
- Counting and filtering rows
- Identifying and handling NULL values
- Data cleaning with `REPLACE()` and type casting
- Creating validation reports
- Writing queries to find data anomalies

**Time:** 20 minutes

**Files:**
- `lesson_3_data_validation/001_ingest.sql` - Load raw subscription data
- `lesson_3_data_validation/002_validate_rows.sql` - Check data quality
- `lesson_3_data_validation/preview_rows.sql` - Preview sample data
- `lesson_3_data_validation/subscriptions.csv` - Sample dataset with intentional errors

## How to Use This Tutorial

1. Open a terminal and navigate to the lessons directory:
   ```bash
   cd tutorials/001_sql_basics
   ```

2. Start with Lesson 1:
   ```bash
   cd lesson_1_basic_ingest_export
   cuiqdata run .
   ```

3. Read the `README.md` in each lesson directory for detailed instructions

4. Examine the SQL files to understand the "why" behind each step

5. Run each `.sql` file individually to see intermediate results:
   ```bash
   cuiqdata run 001_ingest.sql
   cuiqdata run 002_export.sql
   ```

6. Progress to the next lesson once comfortable with the concepts

## Key Concepts Covered

| Concept                 | Why It Matters                                                                          |
| ----------------------- | --------------------------------------------------------------------------------------- |
| **read_csv_auto()**     | Automatically detects column types—no manual schema definition needed                   |
| **read_excel()**        | Load modern office files directly into SQL                                              |
| **CREATE OR REPLACE**   | Idempotent: safe to run multiple times without errors                                   |
| **COPY statement**      | Export data to CSV, TSV, Excel, Parquet, and other formats                             |
| **SELECT queries**      | Filter, sort, and aggregate data with WHERE, ORDER BY, GROUP BY                        |
| **Data Validation**     | Check row counts, nulls, and inconsistencies before using data downstream               |
| **Type Detection**      | Understanding how databases infer types (INT, VARCHAR, DATE, etc.)                      |

## Best Practices Introduced

✓ Always load raw data as-is—preserve the original for debugging  
✓ Use readable column names with snake_case (no spaces)  
✓ Validate data quality early in your pipeline  
✓ Export in formats that your stakeholders need  
✓ Comments explain the "why"; code explains the "how"  
✓ Use `CREATE OR REPLACE TABLE` for safe, repeatable transformations  

## Next Steps

Once comfortable with these fundamentals, move to **Level 2: Basic Pipelines** to learn:
- Multi-step transformation workflows
- Staging layers (Bronze, Silver, Gold)
- Complex aggregations and business metrics
- Real-world e-commerce analytics patterns

## Troubleshooting

**"No SQL files found" error:**
- Ensure you're running `cuiqdata run .` from inside the lesson directory
- Check that SQL files exist: `ls *.sql`

**"File not found" error:**
- Verify the CSV/Excel file exists in the same directory as the SQL file
- Check relative paths in your SQL queries match actual file locations

**Type detection issues:**
- Use explicit casting if `read_csv_auto()` doesn't infer the correct type
- Dates must be in ISO format (YYYY-MM-DD) for automatic detection

**Export not creating a file:**
- Ensure you have write permissions in the current directory
- Check the file path—use relative paths or absolute paths depending on your setup
- Verify the `COPY` statement includes `HEADER` if you want column names

## Quick Reference

**Load any CSV:**
```sql
CREATE OR REPLACE TABLE my_table AS
SELECT * FROM read_csv_auto('./path/to/file.csv');
```

**Load any Excel file:**
```sql
CREATE OR REPLACE TABLE my_table AS
SELECT * FROM read_excel('./path/to/file.xlsx');
```

**Export to CSV:**
```sql
COPY my_table TO 'output.csv' (FORMAT CSV, HEADER);
```

**Basic filtering:**
```sql
SELECT * FROM my_table
WHERE column_name = 'value'
ORDER BY column_name DESC;
```

**Count and aggregate:**
```sql
SELECT COUNT(*), SUM(amount), AVG(amount)
FROM my_table
GROUP BY category;
```
