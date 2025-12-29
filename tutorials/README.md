# cuiqData SQL Tutorials - Complete Curriculum

Welcome to the **cuiqData Local Data Stack** tutorial series. This curriculum teaches SQL fundamentals through real-world data engineering problems, progressing from basic analytics to advanced time-series analysis.

## Philosophy

- **Learn by Doing**: Each tutorial is a complete, executable project
- **Incremental Complexity**: Start with data cleaning, advance to window functions and complex aggregations
- **Real-World Context**: Scenarios are drawn from actual business problems
- **Best Practices Embedded**: DuckDB syntax, snake_case naming, ISO dates, immutability
- **Reproducible**: Sample data included; all queries execute on any DuckDB instance

## The Four Tutorials

### 001: SQL Basics

**Folder**: `001_sql_basics/`

**Duration**: 2-3 hours for beginners

**What You'll Learn**:
- SQL fundamentals and query structure
- File ingestion (CSV, Excel)
- Basic data validation
- Exporting results

**Lessons**:
- `lesson_1_basic_ingest_export/` - Load and export data
- `lesson_2_working_with_excel_files/` - Working with Excel files
- `lesson_3_data_validation/` - Validating data quality

**Next**: Complete lessons in order. Master the fundamentals before moving to 002.

---

### 002: Basic Pipelines (E-Commerce Analytics)

**Folder**: `002_basic_pipelines/`

**Duration**: 2-3 hours for intermediate users

**Prerequisites**: Comfortable with SQL basics (001)

**What You'll Learn**:
- Bronze-Silver-Gold data architecture
- Data cleaning and normalization
- Basic aggregations with GROUP BY
- Exporting results for stakeholders

**Scenario**: Analyze order data to produce a revenue report.

**Key Concepts**:
- Type casting and date normalization
- COALESCE for handling missing values
- Aggregate functions (SUM, COUNT, AVG)
- EXPORT to CSV and Parquet
- Pipeline structure and organization

**Skills Developed**:
✓ Data pipeline thinking (Bronze → Silver → Gold)  
✓ SQL query structure and organization  
✓ Debugging data issues early  
✓ Communicating results to stakeholders  

**Files**:
- `README.md` - Overview and learning goals
- `001_ingest_raw.sql` - Load CSV data
- `002_clean_and_cast.sql` - Standardize types and names
- `003_enrich_metrics.sql` - Calculate business metrics
- `004_export_report.sql` - Deliver to stakeholders
- `challenge.sql` - Hands-on exercises with solutions

**Next**: Complete all files sequentially. Run challenges before moving to 003.

---

### 003: Semistructured Data (User Sessionization)

**Folder**: `003_semistructured_data/`

**Duration**: 2-3 hours for intermediate users

**Prerequisites**: Comfortable with 002 concepts

**What You'll Learn**:
- Window functions (LAG, SUM OVER)
- Gap-based grouping for sessionization
- Cumulative sums for ID generation
- JSON data ingestion and flattening
- Advanced aggregation patterns

**Scenario**: Group user events into sessions, where a session ends after 30+ minutes of inactivity.

**Key Concepts**:
- `LAG()` to detect time gaps
- `SUM() OVER()` cumulative aggregates
- PARTITION BY for per-user calculations
- Boolean flags and CASE expressions
- Session metrics and journey analysis

**Skills Developed**:
✓ Window function mastery  
✓ Gap and state detection  
✓ Building IDs from logic flags  
✓ JSON data handling  
✓ Advanced analytical patterns  

**Files**:
- `README.md` - Overview and key concepts
- `001_ingest_logs.sql` - Load JSON event data
- `002_detect_gaps.sql` - Calculate time deltas with LAG()
- `003_flag_new_sessions.sql` - Identify session boundaries
- `004_assign_session_ids.sql` - Create unique session IDs
- `005_export_results.sql` - Export session data
- `challenge.sql` - Advanced exercises with solutions

**Next**: Master window functions here. They're essential for real-world analytics.

---

### 004: Advanced Pipeline (Time-Series & YoY Analysis)

**Folder**: `004_advanced_pipeline/`

**Duration**: 3-4 hours for advanced users

**Prerequisites**: Solid understanding of 002 and 003

**What You'll Learn**:
- Rolling windows for time-series smoothing
- Year-over-Year and Month-over-Month growth
- Seasonality and anomaly detection
- Trend analysis and forecasting prep
- Period-over-period joins

**Scenario**: Analyze multi-year revenue trends, identify seasonal patterns, and flag anomalies.

**Key Concepts**:
- `ROWS BETWEEN ... AND ...` for rolling windows
- Period extraction (YEAR, MONTH, WEEK)
- Self-joins for YoY comparisons
- Z-scores for anomaly detection
- Day-of-week effects and seasonal decomposition

**Skills Developed**:
✓ Time-series analysis mastery  
✓ Growth metrics and trend analysis  
✓ Seasonality understanding  
✓ Statistical thinking (z-scores, std dev)  
✓ Forecasting preparation  

**Files**:
- `README.md` - Overview and advanced concepts
- `001_prep_daily_sales.sql` - Aggregate into daily totals
- `002_rolling_metrics.sql` - Calculate 7-day and 30-day moving averages
- `003_yoy_growth.sql` - Year-over-year and month-over-month analysis
- `004_advanced_analysis.sql` - Seasonality, anomalies, trends, forecasting
- `005_export_results.sql` - Export analysis results
- `challenge.sql` - Integration exercises with solutions

**Next**: Apply these patterns to your own data. Combine 003 (sessionization) with 004 (time-series) for powerful insights.

---

## How to Use This Curriculum

### For Beginners

1. Start with **001 SQL Basics**. Read the README first.
2. Complete each lesson in order.
3. **Examine the output after each step**. Understand what changed.
4. Read the SQL comments carefully—they explain the "why".
5. Once comfortable, move to **002 Basic Pipelines**.

### For Intermediate Users

1. Skim **001 SQL Basics** quickly (you probably know this stuff).
2. Focus on **002 Basic Pipelines**. Master the Bronze-Silver-Gold pattern.
3. Progress to **003 Semistructured Data**. Window functions are tricky; take time here.
4. Study the cumulative sum trick in `004_assign_session_ids.sql`.
5. Complete all challenges before moving to 004.

### For Advanced Users

1. Scan 002 and 003 to find gaps in your knowledge.
2. Focus on **004 Advanced Pipeline**, especially `004_advanced_analysis.sql`.
3. Adapt the patterns to your own data problems.
4. Consider extending with forecasting, ML feature engineering, or real-time processing.

### In a Team Setting

- Use these tutorials as onboarding material for new analysts
- Customize scenarios to match your business domain
- Share solutions to challenge exercises for knowledge transfer
- Reference these patterns when building new pipelines

---

## Execution Instructions

### Prerequisites

- cuiqData installed
- (Optional) basic SQL knowledge (SELECT, FROM, WHERE)
- A text editor or IDE (VS Code, DBeaver, etc.)

### Running a Tutorial with cuiqData

From the project root:

```bash
# Run a full tutorial
cuiqdata run tutorials/002_basic_pipelines

# Or navigate to the tutorial and run it
cd tutorials/002_basic_pipelines
cuiqdata run <sql directory>
```

---

## Best Practices Summary

These are woven through every tutorial:

### 1. **Immutability**
Create new tables rather than updating rows. This makes debugging easy.

### 2. **Column Naming**
Always use `snake_case`. It's easier to quote and version-control.

### 3. **Dates**
Cast to DATE type. Use ISO 8601 (YYYY-MM-DD) for sorting and display.

### 4. **COALESCE**
Never leave NULLs in metrics. Use COALESCE with sensible defaults.

### 5. **CTEs > Subqueries**
Use `WITH` clauses for readability. Avoid nested parentheses hell.

### 6. **Comments**
Explain the "why" in SQL comments. The "what" should be self-evident.

### 7. **Bronze-Silver-Gold**
- Bronze: Raw data as-is
- Silver: Cleaned, normalized
- Gold: Pre-calculated metrics ready for use

### 8. **Window Functions**
Master `LAG()`, `SUM() OVER()`, and `ROW_NUMBER()`. They replace expensive joins.

### 9. **Aggregation Order**
Always GROUP BY dimensions before calculating metrics.

### 10. **Validation**
Inspect every output. Spot-check totals. Look for suspicious NULLs.

---

## Beyond the Tutorials

### Next Skills to Learn

- **Incremental Pipelines**: Process only new data each run
- **Parameterization**: Make queries reusable with variables
- **Real-Time Processing**: Streaming data ingestion
- **Machine Learning Features**: Prepare data for ML models
- **Advanced Aggregations**: APPROX_COUNT_DISTINCT, QUANTILE_CONT
- **Cross-Period Analysis**: Cohort retention, lifetime value

### Recommended Extensions

1. **Combine Tutorials**: Use sessionization (003) + rolling metrics (004) for user cohort analysis
2. **Add Visualization**: Export to CSV and chart in Excel or Python
3. **Parameterize**: Add variables for date ranges, thresholds, etc.
4. **Automate**: Build cuiqData TOML pipelines to run tutorials daily
5. **Scale**: Try these patterns on larger datasets (millions of rows)

### Resources

- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [Window Functions Guide](https://www.postgresql.org/docs/current/functions-window.html)
- [cuiqData Documentation](../../README.md)

---

## Troubleshooting

### Common Issues

**Q: I get "column does not exist" error**  
A: Check that you ran previous steps in order. Each step builds on the previous table.

**Q: My dates are showing as timestamps**  
A: Cast to DATE: `CAST(timestamp_col AS DATE)`

**Q: GROUP BY is missing a column**  
A: All non-aggregated columns must be in GROUP BY.

**Q: Window function returns NULL**  
A: LAG/LEAD return NULL at the boundaries. Use COALESCE or skip those rows.

**Q: Performance is slow**  
A: For large datasets, pre-aggregate first (e.g., daily totals before rolling metrics).

---

## Contributing

Have improvements? Found a bug? Want to add a Level 4?

Please share feedback in the cuiqData repository. These tutorials evolve with user needs.

---

## License & Citation

These tutorials are part of **cuiqData**, a local-first data orchestration tool.

Citation:
```
cuiqData SQL Tutorials - Learning SQL Through Real Data Problems
Part of cuiqData: Local-First Data Orchestration
```

---

**Happy learning! Start with Level 1 and build your SQL mastery.**
