# Lesson 3: Data Validation

## Overview

Learn how to ensure data quality by validating datasets before processing them. You'll load subscription data with intentional errors, preview the raw data to spot issues, validate row counts and values, and then clean inconsistent data using SQL transformations.

## Learning Goals

- Load raw data as-is using `read_csv_auto()` with `all_varchar=true`
- Preview data samples to spot anomalies and understand quality issues
- Validate data by checking for incorrect values, nulls, and inconsistencies
- Clean data using `REPLACE()` and type casting
- Build queries to find and report data quality problems
- Understand why immutability (never modifying raw data) is important

## Data

The tutorial uses `subscriptions.csv` with columns:
- `id` - Subscription identifier
- `first_name` - Customer first name
- `last_name` - Customer last name
- `subscription_tier` - Either 'free' or 'paid' (but contains typos like 'freee')
- `subscription_date` - Date subscription started
- `email` - Customer email address

Sample data (with intentional errors):
```csv
id,first_name,last_name,subscription_tier,subscription_date,email
1,Alice,Johnson,free,2024-01-15,alice@example.com
2,Bob,Smith,paid,2024-01-16,bob@example.com
3,Charlie,Brown,freee,2024-01-17,charlie@example.com
4,Diana,Prince,free,2024-01-18,diana@example.com
5,Eve,Wilson,paaid,2024-01-19,eve@example.com
```

Notice the errors: row 3 has 'freee' instead of 'free', and row 5 has 'paaid' instead of 'paid'.

## Files in This Lesson

- **001_ingest.sql** - Load the raw CSV file as-is (preserving errors)
- **002_validate_rows.sql** - Find rows with incorrect subscription_tier values
- **preview_rows.sql** - Preview the first 10 rows to spot issues
- **subscriptions.csv** - Sample dataset with intentional data quality issues

## How to Execute the Steps

1. Open a terminal and navigate to this lesson directory:
   ```bash
   cd tutorials/001_sql_basics/lesson_3_data_validation
   ```

2. Preview the raw data to see the problems:
   ```bash
   cuiqdata exec . preview_rows.sql
   ```

   You should see output like:
   ```
   id | first_name | last_name | subscription_tier | subscription_date | email
   ---|------------|-----------|-------------------|-------------------|------------------
   1  | Alice      | Johnson   | free              | 2024-01-15        | alice@example.com
   2  | Bob        | Smith     | paid              | 2024-01-16        | bob@example.com
   3  | Charlie    | Brown     | freee             | 2024-01-17        | charlie@example.com
   ...
   ```

3. Run the pipeline:

```bash
cuiqdata run .
```

   This creates the `raw_subscriptions` table with all columns as VARCHAR (text).

4. Uncomment the query inside `002_validate_rows.sql` and run the pipeline again:
   
```bash
cuiqdata run .
```

5. Rename `002_validate_rows.sql` to `003_validate_rows.sql` and create a new file called `002_clean_data.sql`,
with the following code:

```sql
CREATE OR REPLACE TABLE clean_subscriptions AS 
SELECT
     id
    ,first_name
    ,last_name
    ,REPLACE(subscription_tier,'freee','free') as subscription_tier
    ,subscription_date
    ,email
FROM
    raw_subscriptions
```

This will replace the incorrect 'freee' values with 'free' in the `subscription_tier` column. It will also create a new table called `clean_subscriptions` with the cleaned data.

6. Modify the `002_validate_rows.sql` file to use the `clean_subscriptions` table instead of the `raw_subscriptions` table, and run the pipeline again.

```bash
cuiqdata run .
```

## What's Next

**Calculate statistics**:
   - Consider adding a new transform step to calculate subscriptions statistics

**Create an export of the clean data**:
   - Following previous examples create a new step to export data

## Key Concepts

| Concept                | Why It Matters                                                                           |
| ---------------------- | ---------------------------------------------------------------------------------------- |
| **Immutability**       | Never modify raw data. Always preserve originals for debugging and audits.               |
| **Preview First**      | Look at sample rows before writing complex logic. Humans spot patterns better than code. |
| **all_varchar=true**   | Load everything as text to preserve original values. Type later after cleaning.          |
| **Validation Queries** | Use SQL WHERE clauses to find specific data issues (nulls, typos, out-of-range values).  |
| **NOT IN Operator**    | Find rows that don't match an expected set of values.                                    |
| **REPLACE() Function** | Fix known typos and formatting issues programmatically.                                  |
| **Row Counts**         | Compare before/after counts to ensure your cleaning didn't accidentally drop rows.       |
| **LIMIT Clause**       | Don't print millions of rows—always use LIMIT when previewing.                           |

## Best Practices Introduced

✓ Always load raw data in one table (raw_subscriptions)  
✓ Create a separate "clean" table after validation  
✓ Never modify the raw table—use CREATE OR REPLACE  
✓ Test cleaning logic on samples before applying to all rows  
✓ Document data quality issues in your pipeline comments  
✓ Use validation queries to quantify problems (e.g., "5% of tiers are malformed")  

## Expected Output

**After 001_ingest.sql:**
- A table `raw_subscriptions` with all columns as VARCHAR
- Preserves typos and errors exactly as they appear in the CSV

**After 002_validate_rows.sql (with query uncommented):**
- Query results showing:

  ```
  message          | subscription_tier
  -----------------|------------------
  incorrect tier   | freee
  incorrect tier   | freee
  ...
  ```

## Common SQL Patterns

**Preview sample data:**
```sql
SELECT * FROM raw_subscriptions LIMIT 10;
```

**Count total rows:**
```sql
SELECT COUNT(*) as total_rows FROM raw_subscriptions;
```

**Find rows with specific issues:**
```sql
SELECT * FROM raw_subscriptions
WHERE subscription_tier NOT IN ['free', 'paid']
LIMIT 10;
```

**Count problem rows:**
```sql
SELECT COUNT(*) as bad_tiers
FROM raw_subscriptions
WHERE subscription_tier NOT IN ['free', 'paid'];
```

**Check for NULL values:**
```sql
SELECT * FROM raw_subscriptions
WHERE email IS NULL
   OR first_name IS NULL;
```

**Fix typos with REPLACE:**
```sql
SELECT
    id,
    first_name,
    last_name,
    REPLACE(subscription_tier, 'freee', 'free') as subscription_tier,
    subscription_date,
    email
FROM raw_subscriptions;
```

## Try It Yourself

1. **Count the problems**: Create a query that counts how many rows have each invalid subscription_tier value
   ```sql
   SELECT subscription_tier, COUNT(*) as count
   FROM raw_subscriptions
   WHERE subscription_tier NOT IN ['free', 'paid']
   GROUP BY subscription_tier;
   ```

2. **Preview by tier**: Write a query showing the first 3 rows for each subscription_tier
   ```sql
   SELECT * FROM raw_subscriptions
   WHERE subscription_tier = 'freee'
   LIMIT 3;
   ```

3. **Create a clean table**: Build on what you learned—write a SQL query that creates `clean_subscriptions` using REPLACE to fix the typos
   ```sql
   CREATE OR REPLACE TABLE clean_subscriptions AS
   SELECT
       id,
       first_name,
       last_name,
       REPLACE(REPLACE(subscription_tier, 'freee', 'free'), 'paaid', 'paid') as subscription_tier,
       subscription_date,
       email
   FROM raw_subscriptions;
   ```

4. **Compare counts**: Before and after cleaning, count the rows to ensure nothing was lost
   ```sql
   SELECT COUNT(*) as raw_count FROM raw_subscriptions;
   SELECT COUNT(*) as clean_count FROM clean_subscriptions;
   ```

## Common Errors & Solutions

| Error                                      | Cause                                                                    | Solution                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| `Table not found: raw_subscriptions`       | 001_ingest.sql hasn't been run yet                                       | Run `cuiqdata run 001_ingest.sql` first                                   |
| `Syntax error near 'SELECT'` in preview    | SQL syntax error in preview_rows.sql                                     | Check that SELECT statement is not commented out or malformed             |
| No results from validation query           | The query syntax is correct but the WHERE clause is wrong                | Check column names and values using LIMIT first                           |
| "subscription_tier NOT IN" returns no rows | The typos might be different; check actual values first                  | Run `SELECT DISTINCT subscription_tier FROM raw_subscriptions` to see all |
| Column name has spaces or special chars    | CSV header might have spaces: `subscription tier` vs `subscription_tier` | Quote column names: `"subscription tier"` in SQL                          |

## Workflow Summary

This lesson teaches the **Ingest → Clean → Verify** workflow:

1. **Ingest** - Load raw data as-is, identify problems with SQL queries
2. **Clean** - Create a new table with fixes applied (REPLACE, CAST, NULL handling)
3. **Verify** - Compare row counts and spot-check cleaned data

In the real world, you'd also coordinate with the data source to fix the root cause (e.g., tell the subscription system to not accept typos).

## Next Steps

Once comfortable with validation, explore:

- **Advanced validation**: Check for date formats, email patterns, numeric ranges
- **Cleaning strategies**: When to fix vs. when to flag vs. when to drop rows
- **Data profiling**: Understanding distributions and outliers
- **Level 2: Basic Pipelines** - Learn multi-step workflows with staging layers
