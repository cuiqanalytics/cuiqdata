# Level 4: The Financial Analyst (YoY & Rolling Metrics)

## Overview

In this advanced tutorial, you'll tackle complex time-series analysis: rolling averages, year-over-year growth, and period-over-period comparisons. These are the bread-and-butter of financial and business analysis.

## Prerequisites

- cuiqData installed and working
- Basic terminal/command line skills
- Completion of **Level 2** (or familiarity with `GROUP BY`, `SUM()`, `COUNT()`)

## Learning Goals

- Master **rolling windows** for time-series smoothing
- Calculate **Year-over-Year (YoY)** and **Month-over-Month (MoM)** growth
- Understand **time-series joins** (`ASOF JOIN` in DuckDB)
- Build robust **date filtering** and **calendar logic**
- Design reusable time-series frameworks
- Handle edge cases (missing periods, sparse data)

## Scenario

You're a financial analyst at an e-commerce company. You need to:
1. Calculate daily revenue trends with 7-day moving average (to smooth volatility)
2. Compare this year's performance to last year (YoY growth)
3. Produce dashboards showing "Is revenue trending up or down?"

**Example Output:**
```
Date       Daily Revenue  7-Day Avg  Last Year Revenue  YoY Growth %
2024-01-15      $5,200       $4,850        $3,100         +67.7%
2024-01-16      $5,800       $5,050        $3,400         +70.6%
```

## Key Concepts Covered

| Concept | Why It Matters |
|---------|---|
| **Rolling Windows** | `ROWS BETWEEN N PRECEDING AND CURRENT ROW` smooths noise while preserving trends |
| **ASOF JOIN** | Matches timestamps across periods without exact matches (DuckDB specialty) |
| **Period Extraction** | `YEAR()`, `MONTH()`, `WEEK()` partition data by time buckets |
| **Calendar Handling** | Leap years, month boundaries, timezones—handle them explicitly |
| **Percent Change** | `((new - old) / old) * 100` is the canonical formula |

## Data

Uses `sample_daily_sales.csv` with 2+ years of daily sales data:
```
sales_date,daily_revenue,order_count
2023-01-15,3100,45
2023-01-16,3400,48
...
2024-01-15,5200,75
2024-01-16,5800,82
```

Or reference the `cleaned_orders` table from Level 2 (after running that tutorial).

## How to Use This Tutorial

1. Open a terminal and navigate to this directory:
   ```bash
   cd tutorials/004_advanced_pipeline
   ```

2. Ensure you have `sample_daily_sales.csv` (or use `cleaned_orders` from Level 2)

3. Run the SQL files in order:
   ```bash
   cuiqdata run 001_prep_daily_sales.sql
   cuiqdata run 002_rolling_metrics.sql
   cuiqdata run 003_yoy_growth.sql
   cuiqdata run 004_advanced_analysis.sql
   ```

4. Study `002_rolling_metrics.sql` to understand rolling windows

5. Analyze `003_yoy_growth.sql` for period-over-period logic

6. Explore advanced topics in `004_advanced_analysis.sql`: seasonality, trends, anomalies

7. Complete the challenge to apply your knowledge

## Advanced Topics

- **Seasonality Detection**: Spot repeating patterns (e.g., higher sales on weekends)
- **Anomaly Detection**: Flag unusual days (outliers)
- **Forecast Integration**: Predict next period's revenue
- **Calendar Adjustments**: Account for holidays, leap days
- **Cohort Analysis**: Track customer groups over time

## Files in This Tutorial

- **001_prep_daily_sales.sql** - Validate and prepare daily data
- **002_rolling_metrics.sql** - Calculate moving averages
- **003_yoy_growth.sql** - Period-over-period analysis
- **004_advanced_analysis.sql** - Seasonality, trends, anomalies
- **challenge.sql** - Hands-on exercises
