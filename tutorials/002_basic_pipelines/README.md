# Level 2: Data Engineering Foundation (E-Commerce Analytics)

## Overview

In this tutorial, you'll learn the fundamentals of data analytics by working through a real-world e-commerce problem. You'll ingest messy CSV data, clean it, and produce a report ready for dashboards.

## Prerequisites

- cuiqData installed and working (`cuiqdata --version` should show a version number)
- Basic terminal/command line skills (see TERMINAL.md in the parent directory)
- Familiarity with basic SQL `SELECT`, `FROM`, `WHERE` (optional; this tutorial teaches you)

## Learning Goals

- Understand a basic data pipeline pattern
- Learn `read_csv_auto()` for automatic type detection
- Master data cleaning with `CAST`, `COALESCE`, and string normalization
- Calculate aggregate metrics with `GROUP BY`
- Export data to formats usable by Excel, Power BI, and other tools

## Scenario

You work as an analyst at "DuckStore", an online retailer. You've received a CSV export of raw orders with inconsistent formatting. Your task is to produce a clean revenue report by city ready for presentation to stakeholders.

## Key Concepts Covered

| Concept                | Why It Matters                                                                          |
| ---------------------- | --------------------------------------------------------------------------------------- |
| **Bronze Layer**       | Store raw data as-is. Never transform the original—you'll need it for debugging.        |
| **Silver Layer**       | Fix types, normalize column names, handle missing values.                               |
| **Gold Layer**         | Pre-calculated metrics ready for visualization. Think "answer a question in one query." |
| **ISO 8601 Dates**     | `2024-12-25` instead of `12/25/2024`. Standard, unambiguous, sortable.                  |
| **snake_case Naming**  | `order_id` not `Order ID`. Easier to quote, query, and version control.                 |
| **COALESCE for NULLs** | Never leave missing values in metrics. Use a sensible default.                          |

## Data

You'll need a sample CSV file at `data/messy_orders.csv` with columns like:
- `Order ID`
- `Customer Name`
- `Order Date` (in MM/DD/YYYY format)
- `Sales Amount` (may have missing values)
- `City`

Sample format:
```csv
Order ID,Customer Name,Order Date,Sales Amount,City
1001,Alice Johnson,01/15/2024,249.99,New York
1002,Bob Smith,01/16/2024,,Los Angeles
1003,Charlie Brown,01/17/2024,175.50,chicago
```

## How to Use This Tutorial

1. Open a terminal and navigate to this directory:
   ```bash
   cd tutorials/002_basic_pipelines
   ```

2. Ensure you have the sample data in `data/messy_orders.csv`

3. Run the SQL files in order:
   ```bash
   cuiqdata run 001_ingest_raw.sql
   cuiqdata run 002_clean_and_cast.sql
   cuiqdata run 003_enrich_metrics.sql
   cuiqdata run 004_export_report.sql
   ```

4. Read the SQL comments carefully—they explain the "why" behind each step

5. Examine the output tables after each step to see the transformation

6. Complete the challenge at the end to solidify your learning

## Files in This Tutorial

- **001_ingest_raw.sql** - Load the raw CSV
- **002_clean_and_cast.sql** - Standardize types and column names
- **003_enrich_metrics.sql** - Calculate business metrics
- **004_export_report.sql** - Export to formats ready for stakeholders
- **challenge.sql** - (Optional) Test your skills

## Best Practices Introduced

✓ Immutability: Create new tables rather than updating rows  
✓ Incremental processing: Each step builds on the previous one  
✓ Comments as documentation: Explain the "why" in code  
✓ Early validation: Fix data type issues in the cleaning step  
✓ Ready-to-use outputs: Gold tables should be usable as-is  

## Next Steps

Once comfortable with this level, move to **Level 2** to tackle more complex problems using window functions and advanced aggregations.
