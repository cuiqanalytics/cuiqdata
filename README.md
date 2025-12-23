# cuiqData: Fast, Local SQL Orchestration

![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux-blue) ![DuckDB](https://img.shields.io/badge/engine-DuckDB-yellow) ![Local First](https://img.shields.io/badge/local--first-yes-success) ![Single Binary](https://img.shields.io/badge/single--binary-yes-informational) ![No Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

cuiqData lets you build and run data pipelines using **only SQL** — locally, fast, and without infrastructure.

No Airflow. No Kubernetes. No Python DAGs. Just numbered SQL files, instant feedback, and cached re-runs.

Install once. Then build pipelines in minutes.

## Installation

**Download** executables or installers for your platform from [Releases](https://github.com/cuiqanalytics/cuiqdata/releases) and follow the instructions provided there.

---

## ⚡ Quick Start (Your First Pipeline)

Once installed, open a terminal:

**macOS**:
1. Press `Cmd + Space` to open Spotlight
2. Type `terminal` and press Enter
3. A Terminal window opens

**Windows**:
1. Press `Win + R` to open Run dialog
2. Type `cmd` and press Enter
3. A Command Prompt window opens (or use PowerShell)

```bash
# 1. Create a demo pipeline
cuiqdata demo
cd demo

# 2. Run it
cuiqdata run .
```

## How cuiqData Works (Mental Model)

1. Each `.sql` file = one pipeline step
2. The filename order defines execution order
3. Each step produces a table:
   - `001_ingest.sql` → `raw_data`
   - `002_transform.sql` → `transformed_data`
4. Results are cached automatically
5. An execution log is generated for traceability

## Choose Your Path

### 📊 Option A: Beginners

Learn data pipelines with simple SQL. Create numbered SQL files, no configuration needed.

**Step 1: Create your project**

Choose a directory for your project and create the following directory structure:

```
my_project
├── data
├── output
└── sql
```

**Step 2: Create SQL files (use any text editor: Notepad, Notepad++, VSCode, Sublime, etc.)**

Create the following files with `.sql` extension (very important) and save them in the `sql` folder:

`sql/001_ingest.sql`:
```sql
-- Note: Lines starting with "--" are comments and are ignored when processing the file

-- Load data from a CSV file
SELECT * FROM read_csv_auto('data/input.csv')
```

`sql/002_transform.sql`:
```sql
-- Simple transformation: filter and count
SELECT 
  category,
  COUNT(*) as total_records,
  ROUND(AVG(amount), 2) as avg_amount
FROM raw_data
WHERE amount > 0
GROUP BY category
ORDER BY total_records DESC
```

`sql/003_export.sql`:
```sql
-- Export final results
SELECT * FROM transformed_data
```

**Step 3: Open a Terminal**

**macOS**:
1. Press `Cmd + Space` to open Spotlight
2. Type `terminal` and press Enter
3. A Terminal window opens

**Windows**:
1. Press `Win + R` to open Run dialog
2. Type `cmd` and press Enter
3. A Command Prompt window opens (or use PowerShell)


**Step 4: Run your pipeline**
```bash
cuiqdata run ./sql
```

That's it! Your SQL files execute in order (001 → 002 → 003), and results are cached for fast re-runs.

**Modify and re-run**:
- Open any SQL file in your editor
- Change the query
- Run `cuiqdata run ./sql` again
- Try re-running from another cached step, i.e. 2: `cuiqdata run --start-step 2 ./sql`

How to continue? Check out the [tutorials](tutorials/)

---

### 🚀 Option B: For Data Engineers (SQL or TOML)

**For experienced engineers**: Use whichever style fits your workflow.

#### Option B1: SQL-First (Pure SQL, Minimal Config)

```bash
cd my_project

# Create numbered SQL files
mkdir -p sql
cat > sql/001_ingest.sql << 'EOF'
-- Load raw data from CSV
SELECT * FROM read_csv_auto('data/sales.csv')
EOF

cat > sql/002_transform.sql << 'EOF'
-- Monthly aggregation (DuckDB syntax)
SELECT 
  DATE_TRUNC('month', order_date) as month,
  SUM(amount) as revenue,
  COUNT(*) as order_count
FROM raw_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC
EOF

cat > sql/003_sink.sql << 'EOF'
-- Export results
SELECT * FROM transformed_data
EOF

# Run the pipeline
cuiqdata run ./sql
```

**Why this approach?**
- Direct: No translation layer between you and DuckDB
- Fast to iterate: Edit SQL, run
- Minimal overhead: One file = one step

#### Option B2: TOML + SQL (Advanced Config)

```bash
cuiqdata init my_project
cd my_project
cuiqdata run .
```

Use `pipeline.toml` when you need:
- Multi-source ingestion
- Complex validation rules
- Template variables (dates, paths, etc.)
- Team collaboration features

```bash
cuiqdata init my_project
cd my_project

# Edit pipeline.toml for advanced features
nano pipeline.toml
```

---

## Features

- **Local-first**: No infrastructure. DuckDB + SQLite, everything local.
- **Lightning-fast**: Step-level caching delivers 100x speedups on re-runs.
- **SQL + Config**: Write DuckDB SQL directly (no YAML or Python DSLs).
- **Zero dependencies**: Single binary. No Python, Node, Rust.
- **Immutable logs**: Execution history with event-sourcing for reproducibility.

---

## Common Tasks

**See what changed between runs**:
```bash
cuiqdata report ./sql
# Generates: execution_report.html (step timings, cache info, row counts)
```

**Validate before executing**:
```bash
cuiqdata test pipeline.toml
# Checks syntax, validates table references, catches errors early
```

**Learn by example**:
```bash
# Built-in interactive tutorial
cuiqdata tutorial

# View all documentation
cuiqdata docs

# Check specific topics
cuiqdata docs config
cuiqdata docs steps
cuiqdata docs templating
```

---

## When to Use Each Option

| Aspect             | Option A (Beginners)    | Option B1 (SQL-Only)             | Option B2 (TOML)                     |
| ------------------ | ----------------------- | -------------------------------- | ------------------------------------ |
| **Best for**       | Learning the basics     | Fast iteration, simple pipelines | Complex workflows, advanced features |
| **Setup time**     | ~60 sec                 | ~30 sec                          | ~60 sec                              |
| **Modification**   | Edit .sql files         | Edit .sql files                  | Edit .toml config                    |
| **Learning curve** | Gentle introduction     | Minimal if you know SQL          | Need TOML knowledge                  |
| **Scalability**    | Up to medium complexity | Straightforward for any size     | Best for complex orchestration       |

**Path Flow**: Most users start with **Option A**, move to **Option B1** (SQL-First) as they grow, then add **Option B2** (TOML) features as needed.

---

## Why cuiqData Instead of Bash Scripts?

Bash scripts are great for one-off automation, but they fall apart with data pipelines:

| Problem                      | Bash Script                                              | cuiqData                                                    |
| ---------------------------- | -------------------------------------------------------- | ----------------------------------------------------------- |
| **Re-runs take forever**     | Every step runs again, even if nothing changed           | Step-level caching skips unchanged work                     |
| **Debugging is painful**     | Print statements everywhere; hard to track what happened | Full execution history with timestamps, row counts, runtime |
| **Dependencies are fragile** | If step 5 fails, you manually re-run from step 1         | Resume from any step; dependency-aware execution            |
| **No data validation**       | Garbage in = garbage out                                 | Schema validation, row count tracking, data quality checks  |
| **Team collaboration**       | "Works on my machine"                                    | Reproducible runs with immutable logs                       |
| **Monitoring is manual**     | Tail logs; hope nothing breaks                           | Execution reports with step timings, cache info, row counts |
| **Infrastructure overhead**  | Works locally, scales poorly                             | Single binary; runs anywhere (laptop, server, container)    |

**Real example**: A 10-step ETL pipeline with bash:
- Initial run: 5 minutes
- Fix a typo in step 7: 5 minutes again (all steps re-run)
- With cuiqData: 5 seconds (only step 7 re-runs)

**Plus**: SQL is the universal data language. No learning Python DAGs or YAML syntax—just SQL you already know.

---

## What's Next?

- ⭐ [Star on GitHub](https://github.com/cuiqdata/cuiqdata)
- 💬 [Join our Discord](https://discord.gg/cuiqdata)
- 🚀 [Pro Features](https://www.cuiqanalytics.com/cuiqdata.html)

---

Built with ❤️ for data teams that value speed and SQL.
