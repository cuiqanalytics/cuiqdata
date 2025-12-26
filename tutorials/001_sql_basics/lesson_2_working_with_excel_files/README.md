# Lesson 2: Working with Excel Files

## Overview

Learn how to load data from Excel files and perform aggregations. You'll work with a purchases dataset to understand data loading, transformations, and export to Excel format.

## Learning Goals

- Load Excel files using DuckDB's EXCEL extension
- Aggregate data using `GROUP BY`, `SUM()`, `COUNT()`, and `AVG()`
- Export results back to Excel format
- Understand basic SQL aggregation functions

## Data

The tutorial uses `purchases.xlsx` with columns:
- `serial_id` - Unique transaction identifier
- `first_name` - Customer first name
- `last_name` - Customer last name
- `amount` - Purchase amount (1000–2000)
- `category` - Product category

## Files in This Lesson

- **001_ingest.sql** - Load the Excel file using the EXCEL extension
- **002_aggregate.sql** - Create a summary report grouped by category
- **003_export_excel.sql** - Export the summary back to Excel
- **purchases.xlsx** - Sample purchase transaction data

## How to Execute This Lesson

Navigate to this directory and run:

```bash
cuiqdata run .
```

This executes all SQL files in order (001, 002, 003).

## How to Use This Lesson

1. Read `001_ingest.sql` - See how to load Excel files
2. Run `001_ingest.sql` to create the `purchases` table
3. Read `002_aggregate.sql` - Understand GROUP BY and aggregate functions
4. Run `002_aggregate.sql` to create the `sales_summary` table
5. Read `003_export_excel.sql` - Learn how to export to Excel
6. Run `003_export_excel.sql` to create `sales_summary.xlsx`
7. Open `sales_summary.xlsx` to see the results

## Key Concepts

| Concept          | Why It Matters                                                           |
| ---------------- | -------------------------------------------------------- |
| **EXCEL extension** | Allows DuckDB to read/write Excel files natively |
| **GROUP BY**     | Groups rows by category to perform calculations per group |
| **COUNT(*)**     | Counts rows in each group |
| **SUM(column)**  | Totals numeric values for each group |
| **AVG(column)**  | Calculates average value for each group |

## Expected Output

After running this lesson, you will have:

**After 001_ingest.sql:**
- A table named `purchases` with 100+ rows
- Columns: `serial_id`, `first_name`, `last_name`, `amount`, `category`

**After 002_aggregate.sql:**
- A table named `sales_summary` grouped by category
- Example output:
  ```
  category       | num_items_sold | total_sales | average_price
  ---------------+----------------+-------------+--------------
  Electronics    |      25        |    45000    |     1800
  Clothing       |      30        |    39000    |     1300
  Home & Garden  |      45        |    67500    |     1500
  ```

**After 003_export_excel.sql:**
- A file named `sales_summary.xlsx` ready to open in Excel
- Contains the summary table with formatted columns

## Quick Reference: Common SQL Patterns

**Load an Excel file:**
```sql
INSTALL EXCEL;
LOAD EXCEL;
CREATE OR REPLACE TABLE my_table AS
SELECT * FROM './my_file.xlsx';
```

**Aggregate data by group:**
```sql
CREATE OR REPLACE TABLE summary AS
SELECT 
    category,
    COUNT(*) AS count,
    SUM(amount) AS total,
    AVG(amount) AS average
FROM purchases
GROUP BY category;
```

**Export to Excel:**
```sql
LOAD EXCEL;
COPY summary TO './output.xlsx' (HEADER TRUE);
```

**Preview aggregations:**
```sql
SELECT category, COUNT(*) as count FROM purchases GROUP BY category;
```

## Try It Yourself

1. **Add a new metric**: Modify `002_aggregate.sql` to include `MIN(amount)` and `MAX(amount)` for each category
   - These show the cheapest and most expensive items per category

2. **Filter results**: Add a `HAVING` clause to show only categories with more than 20 items sold
   - Example: `HAVING COUNT(*) > 20`

3. **Sort results**: Add `ORDER BY total_sales DESC` to show top-selling categories first

## Common Errors & Solutions

| Error | Cause | Solution |
| ----- | ----- | -------- |
| `Failed to install EXCEL` | EXCEL extension not available for your DuckDB version | Update DuckDB to latest version |
| `File not found: ./purchases.xlsx` | Excel file not in current directory | Ensure `purchases.xlsx` is in the same directory as SQL files |
| `column "category" must appear in the GROUP BY clause` | Using non-grouped column in SELECT | Only select columns that are in GROUP BY or aggregated with SUM/COUNT/AVG |
| Excel file won't open after export | File locked by system or incomplete write | Close any open Excel instances and rerun the export |

## Next Steps

Once comfortable with aggregations, explore filtering with `WHERE`, joining multiple tables, and creating more complex summaries.
