# Lesson 1: Ingest & Export delimited files (CSV)

## Overview

Learn the fundamentals of loading data into a database and exporting it. You'll work with a simple animals dataset to understand how data flows through a SQL pipeline.

## Learning Goals

- Load CSV data into a table using `CREATE OR REPLACE TABLE` and `read_csv_auto()`
- Understand automatic type detection with `read_csv_auto()`
- Export data to different formats using `COPY`
- Work with DuckDB syntax basics

## Data

The tutorial uses `animals.csv` with columns:
- `Animal Type` - Type of animal (Dog, Cat, etc.)
- `Breed` - Specific breed name

Sample data:
```csv
Animal Type,Breed
Dog,Labrador Retriever
Dog,German Shepherd
Cat,Siamese
Cat,Persian
Cat,Maine Coon
...
```

## Files in This Lesson

- **001_ingest.sql** - Load the CSV file into a table using `read_csv_auto()`
- **002_export.sql** - Export the loaded table to a tab-delimited file
- **animals.csv** - Sample data file

## How to execute the steps

- Open a terminal and navigate to the directory containing this lesson
- Check you are in the correct directory by executing the following command: 

```bash
dir
```

You should see the following list of files:

```
001_ingest.sql
002_export.sql
animals.csv
README.md
```

The, run the following command to execute the SQL scripts (notice the `.` at the end, that means "current directory"):

```bash
cuiqdata run .
```

You should see an output similar to the following:

```
✓ Ingesting data: ingest... 
✓ Sinking data: export... 

✅ Pipeline completed in 258ms
   📊 2/2 steps executed (100%)
   ⏱️  Duration: 258ms
   📈 Total rows processed: 28
```

## What's next

1. Read `001_ingest.sql` - Understand how `read_csv_auto()` automatically detects column types
2. Run `001_ingest.sql` to create the `animal_data` table
3. Read `002_export.sql` - Learn how `COPY` exports tables to files
4. Run `002_export.sql` to create `animal_data.txt`
5. Examine the output file to see the format transformation

## Key Concepts

| Concept               | Why It Matters                                                                |
| --------------------- | ----------------------------------------------------------------------------- |
| **read_csv_auto()**   | Automatically detects column types so you don't have to specify them manually |
| **CREATE OR REPLACE** | Idempotent: safe to run multiple times without errors                         |
| **COPY statement**    | Export data to CSV, TSV, Parquet, and other formats                           |
| **Delimiter**         | Tab (`\t`), comma (`,`), or pipe (`\|`) for different file formats            |

## Expected Output

After running this lesson, you will have:

**After 001_ingest.sql:**
A table named `animal_data` in your database with columns: `Animal Type` (VARCHAR), `Breed` (VARCHAR)

**After 002_export.sql:**
- A file named `animal_data.txt` in the same directory
- Tab-delimited format (columns separated by tabs)
- Header row included
- Content similar to:
  ```
  Animal Type	Breed
  Dog	Labrador Retriever
  Dog	German Shepherd
  ...
  ```

## Quick Reference: Common SQL Patterns

**Load any CSV file:**
```sql
CREATE OR REPLACE TABLE my_table AS
SELECT * FROM read_csv_auto('./path/to/file.csv');
```

**Export with different delimiters:**
```sql
-- CSV (comma-separated)
COPY my_table TO 'output.csv' (FORMAT CSV, HEADER);

-- TSV (tab-separated)
COPY my_table TO 'output.tsv' (FORMAT CSV, HEADER, DELIMITER '\t');

-- Pipe-separated
COPY my_table TO 'output.txt' (FORMAT CSV, HEADER, DELIMITER '|');
```

## Try It Yourself

1. **Export as CSV**: Modify `002_export.sql` to export as a CSV file instead of TSV
   - Change delimiter to `,` and filename to `animal_data.csv`

2. **Select specific columns**: Create a new SQL file that exports only the `Breed` column
   - Use `SELECT Breed FROM animal_data` instead of `SELECT *`

3. **Add a filter**: Export only dogs to a new file
   - Add `WHERE "Animal Type" = 'Dog'` to the SELECT statement

## Common Errors & Solutions

| Error                                                            | Cause                                                                    | Solution                                                                             |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| `[ERROR] No SQL files found in: .`                               | You are running cuiqdata from the wrong directory                        | Use command terminals to navigate to the root directory of the lesson                |
| `[ERROR] Missing or invalid required argument for "run" command` | You need to provide the directory name where the `sql` files are located | Add `.` to the end of the command `cuiqdata run .`                                   |
| `[ERROR] Cannot find TOML filename or SQL directory: sql`        | You provided and incorrect directory name                                | Check you are located in the root directory of the lesson where the `.sql` files are |

## Next Steps

Once comfortable with basic ingest and export, explore more advanced transformations and data cleaning techniques.
