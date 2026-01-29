# cuiqData: Fast, Local SQL Orchestration

![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux-blue) ![DuckDB](https://img.shields.io/badge/engine-DuckDB-yellow) ![Local First](https://img.shields.io/badge/local--first-yes-success) ![Single Binary](https://img.shields.io/badge/single--binary-yes-informational) ![No Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)

cuiqData lets you build and run data pipelines using **only SQL** — locally, fast, and without infrastructure.

No Airflow. No Kubernetes. No Python DAGs. Just numbered SQL files, instant feedback, and cached re-runs.

Install once. Then build pipelines in minutes.

![Demo](demo.gif)

## Versions

**cuiqData Free** (this repository) provides local SQL orchestration for individual developers and small teams. It includes all core features: pipeline execution, caching, logging, and reports.

**cuiqData Pro** offers advanced features for teams running pipelines in production, including scheduling, database connectors, alerts, performance monitoring, and data quality rules. Learn more at [cuiqData](https://www.cuiqanalytics.com/cuiqdata.html).

---

## Installation

**Download** executables or installers for your platform from [Releases](https://github.com/cuiqanalytics/cuiqdata/releases) and follow the instructions provided there.

---

## ⚡ Quick Start Demo (Your First Pipeline)

### Opening a terminal session

Not familiar with the Terminal? Check the tutorial [Terminal Basics](tutorials/TERMINAL_BASICS.md) for a quick introduction.

Once cuiqData is installed, you can run a demo pipeline to see how it works. cuiqData is a **command line tool** that works in a terminal, so first thing to do is to open a terminal in your operating system.

**In Linux** use the instructions from your distribution, and make sure to add the command to your path.

**In macOS**:
1. Press `Cmd + Space` to open Spotlight
2. Type `terminal` and press Enter
3. A Terminal window opens

**In Windows**:
1. Press `Win + R` to open Run dialog
2. Type `cmd` and press Enter
3. A Command Prompt window opens (or use PowerShell)

### Creating the demo project

First task will be creating a "demo" project with a single pipeline.

Inside the terminal you opened from the previous step enter the following commands (each line followed by Enter):

```bash
cuiqdata demo
cd demo
```

This will create a new directory called "demo" with the following structure:

```
demo
├── data
├── output
└── sql
```

- **data** contains sample data files for the demo.
- **output** is where the results of the pipeline steps are stored.
- **sql** is where the SQL files to be executed are stored.


Enter the following commnand and press Enter:

```bash
cuiqdata run sql
```

Watch the results. The output will be displayed in the terminal, like this:

```
✓ Ingesting data: ingest...
✓ Transforming: transform...
✓ Sinking data: validate...

✅ Pipeline completed in 399ms
   📊 3/3 steps executed (100%)
   ⏱️  Duration: 399ms
   📈 Total rows processed: 30
```

Congratulations! You've run your first pipeline with cuiqData.  The results are stored in the `output/results.csv` file.

### What's next

Use your favorite text editor or IDE and open the `002_transform.sql` file. Make some changes, for example, let's change de `002_transform.sql`. Locate the line with `username` and change it to `UPPER(username) as username_upper`, like the following: 

```sql
-- Classify users by tier and extract year
CREATE OR REPLACE TABLE transform AS
SELECT
  id,
  UPPER(username) as username_upper,
  score,
  signup_date,
  CASE 
    WHEN score >= 800 THEN 'platinum'
    WHEN score >= 600 THEN 'gold'
    WHEN score >= 400 THEN 'silver'
    ELSE 'bronze'
  END as tier,
  YEAR(signup_date) as signup_year
FROM ingest
```

Save your file. Make sure the extension is `.sql` (and not `.sql.txt`)

What are we doing? `UPPER` is a SQL function that converts all characters in a string to uppercase. So, in the transform step where are changing the username field to uppercase.

Save and close the file, and then run the pipeline again:

```
cuiqdata run sql
```

You should see the same output as before, but this time the username field will be in uppercase. Open the `output/results.csv` file to see the updated results.

###  How cuiqData Works (Mental Model)

1. Each `.sql` file = one pipeline step
2. The filename order defines execution order
3. Each step produces a table:
   - `001_ingest.sql` → `raw_data`
   - `002_transform.sql` → `transformed_data`
4. Results are cached automatically
5. An execution log is generated for traceability

### What's next?

Check out the [tutorials](tutorials/)

## Advanced users

### 📊 SQL Mode

SQL Mode works with sequentially numbered SQL files, no configuration needed.

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

Open a terminal in the root directory of your project and run cuiqdata passing the path to the SQL directory:

```bash
cuiqdata run ./sql
```

That's it! Your SQL files execute in order (001 → 002 → 003), and results are cached for fast re-runs.

**Modify and re-run**:
- Open any SQL file in your editor
- Change the query
- Run `cuiqdata run ./sql` again
- Try re-running from another cached step, i.e. 2: `cuiqdata run --start-step 2 ./sql`

---

### 🚀 Working with a TOML configuration

Optionally, cuiqData can use a TOML file to configure your pipeline, for example:



```bash
cuiqdata init my_project
cd my_project
cuiqdata run pipeline.toml
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
cuiqdata run pipeline.toml
```

---

## 🗓️ Background Scheduler

cuiqData includes a **production-ready background scheduler** for running pipelines on a schedule. No additional infrastructure needed—just cron expressions and local SQLite.

### Quick Start: Schedule a Pipeline

**Step 1: Start the scheduler**
```bash
cuiqdata server start
```
The scheduler runs on `127.0.0.1:5000` and monitors scheduled pipelines every 60 seconds.

**Step 2: Queue a pipeline for async execution**
```bash
# Fire-and-forget: returns immediately with a run ID
cuiqdata run --scheduler my_pipeline

# Output:
# ✅ Pipeline queued successfully
# Pipeline: my_pipeline
# Run ID: abc123-def456
# 📊 Monitor execution: cuiqdata logs abc123-def456
```

**Step 3: Monitor execution via REST API**
```bash
# Check scheduler status
curl http://127.0.0.1:5000/api/status

# View execution logs
curl http://127.0.0.1:5000/api/logs?limit=10

# Get diagnostics
curl http://127.0.0.1:5000/api/diagnostics
```

### Cron-Based Scheduling

Schedule pipelines using standard cron expressions:

```bash
# Create a cron schedule via API
curl -X POST http://127.0.0.1:5000/api/pipelines/my_pipeline/schedule \
  -d '{"cron": "0 9 * * 1-5"}'
# Runs weekdays at 9am
```

**Supported cron formats:**
- `0 9 * * 1-5` - Weekdays at 9am
- `*/5 * * * *` - Every 5 minutes
- `0 0 1 * *` - Monthly on the 1st
- `@hourly` / `@daily` / `@weekly` - Special strings

### Key Features

✅ **Fire-and-Forget Execution** - Queue pipelines and let the scheduler handle it  
✅ **Cron-Based Scheduling** - Standard 5-field cron expressions  
✅ **Complete Audit Trail** - All operations logged for reproducibility  
✅ **REST API Access** - 25+ endpoints for monitoring and control  
✅ **Zero Infrastructure** - Runs locally with SQLite  
✅ **Automatic Cleanup** - Old runs cleaned up automatically  
✅ **Duplicate Prevention** - Prevents multiple runs within check interval  

### API Endpoints

**Pipeline Management:**
- `POST /api/pipelines/:name/trigger` - Manually trigger a pipeline
- `GET /api/pipelines` - List all scheduled pipelines
- `GET /api/pipelines/:name` - Get pipeline details

**Run Management:**
- `GET /api/runs` - List recent runs
- `GET /api/runs/:run_id` - Get run details
- `GET /api/runs/:run_id/steps` - Get step execution details
- `POST /api/runs/:run_id/replay` - Re-execute a previous run
- `POST /api/runs/:run_id/cancel` - Cancel a running pipeline

**Logs & Export:**
- `GET /api/logs` - View execution logs with pagination
- `GET /api/logs/:run_id` - Logs for specific run
- `GET /api/export/logs?format=csv` - Export logs (JSON or CSV)

**Monitoring & Settings:**
- `GET /api/status` - Scheduler status and stats
- `GET /api/diagnostics` - Detailed health metrics
- `GET /api/settings` - Current configuration
- `POST /api/settings` - Update configuration

### Traditional vs Async Execution

| Aspect         | Traditional      | With --scheduler         |
| -------------- | ---------------- | ------------------------ |
| **Execution**  | Synchronous      | Asynchronous             |
| **CLI waits**  | Yes              | No (returns immediately) |
| **Monitoring** | Real-time in CLI | Via API/Web UI           |
| **Return**     | Results          | Run ID                   |
| **Use case**   | Development      | Production scheduling    |

```bash
# Traditional: waits for completion
cuiqdata run my_pipeline

# Async: returns immediately
cuiqdata run --scheduler my_pipeline
```

### Common Scheduler Tasks

**View all runs:**
```bash
curl http://127.0.0.1:5000/api/runs?limit=20
```

**Get a specific run status:**
```bash
curl http://127.0.0.1:5000/api/runs/abc123-def456
```

**Export logs to CSV:**
```bash
curl http://127.0.0.1:5000/api/export/logs?format=csv > logs.csv
```

**Get scheduler health:**
```bash
curl http://127.0.0.1:5000/api/diagnostics
```

### Advanced: Cron Expressions

Full cron expression support with examples:

```
0 9 * * 1-5      # Weekdays at 9:00 AM
0 */6 * * *      # Every 6 hours
30 2 * * *       # Daily at 2:30 AM  
0 0 1 * *        # Monthly on the 1st
0 0 * * 0        # Weekly on Sunday
*/15 * * * *     # Every 15 minutes
@hourly          # Top of every hour
@daily           # Midnight daily
@weekly          # Sunday midnight
@monthly         # 1st of month at midnight
@yearly          # January 1st at midnight
```

### Scheduler Configuration

Configure via the REST API:

```bash
# Get current settings
curl http://127.0.0.1:5000/api/settings

# Update settings
curl -X POST http://127.0.0.1:5000/api/settings \
  -d '{"check_interval_secs": "60", "max_age_hours": "720"}'
```

**Configuration Options:**
- `check_interval_secs` - How often to check schedules (default: 60)
- `max_age_hours` - Keep runs for N hours before cleanup (default: 720 = 30 days)
- `log_level` - Logging verbosity (default: info)

### Database

Scheduler data is stored in `~/.cuiqdata/scheduler.db` (SQLite):
- Separate from main cuiqData database
- 4 tables: scheduled_pipelines, pipeline_runs, pipeline_run_steps, scheduler_state
- Automatic schema creation
- Full audit trail via event logging

---

## Features

- **Local-first**: No infrastructure. DuckDB + SQLite, everything local.
- **Lightning-fast**: Step-level caching delivers 100x speedups on re-runs.
- **SQL + Config**: Write DuckDB SQL directly (no YAML or Python DSLs).
- **Zero dependencies**: Single binary. No Python, no Node, no Rust.
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
# View all documentation
cuiqdata docs

# Check specific topics
cuiqdata docs config
cuiqdata docs steps
cuiqdata docs templating
```

---

## Why cuiqData instead of Bash scripts?

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

### Want to schedule pipelines?
See the **Background Scheduler** section above for cron-based automation without extra infrastructure.

### Learn more:
- ⭐ [Star on GitHub](https://github.com/cuiqanalytics/cuiqdata)
- 💬 [Join our Discord](https://discord.gg/3yhqhZ4RR8)
- 📚 [Full Documentation](SCHEDULER_QUICK_START.md) - Scheduler usage guide
- 🚀 [Pro Features](https://www.cuiqdata.com)

---

Built with ❤️ for data teams that value speed and SQL.
