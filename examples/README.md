# cuiqData Examples

A collection of example pipelines demonstrating cuiqData capabilities across different scenarios and complexity levels.

## Quick Start

All examples can be run from the project root:

```bash
cuiqdata run examples/<example_name>
```

Or from within the examples directory:

```bash
cd examples/<example_name>
cuiqdata run <example_name>
```

## Examples Overview

### Foundational Examples

#### **simple_toml**

Minimal TOML-based pipeline configuration.

- Single pipeline definition with basic metadata
- Good starting point for understanding configuration syntax
- No SQL execution, mainly demonstrates config structure

#### **simple_csv_processing**

Simplest working pipeline without explicit TOML configuration.

- Three SQL files: load, transform, export
- Auto-detected pipeline name from directory
- Demonstrates SQL Direct mode with automatic defaults
- **Run**: `cuiqdata run examples/simple_csv_processing`

### Business Domain Examples

#### **ecommerce_orders**

Comprehensive order processing pipeline for e-commerce businesses.

- **Use case**: Ingest, clean, validate, and analyze e-commerce orders
- **Key features**:
  - Multiple data sources (orders and line items)
  - Data cleaning and standardization
  - Order enrichment with computed tiers
  - Multi-stage validation with data quality checks
  - Dual output formats (CSV for fulfillment, Parquet for analytics)
- **10 SQL steps** covering full data pipeline lifecycle
- **Outputs**: fulfillment_report.csv, order_analytics.parquet
- **Run**: `cuiqdata run examples/ecommerce_orders`

#### **financial_transactions**

Compliance and risk analysis for financial transaction data.

- **Use case**: Process, validate, and audit financial transactions
- **Key features**:
  - Multi-source ingestion (transactions, accounts, counterparties)
  - Data cleaning and normalization
  - Transaction enrichment with counterparty context
  - Suspicious pattern detection
  - Compliance summary reporting
- **13 SQL steps** demonstrating complex financial workflows
- **Outputs**: suspicious_patterns.parquet, compliance_summary.csv, enriched_transactions.parquet
- **Run**: `cuiqdata run examples/financial_transactions`

#### **healthcare_claims**

Insurance claims processing pipeline with data quality validation.

- **Use case**: Process and validate healthcare insurance claims
- **Key features**:
  - Claims ingestion and patient data enrichment
  - Clinical validation rules
  - Financial reconciliation
  - Claim status tracking and reporting
- **Multi-stage processing** demonstrating healthcare domain patterns
- **Run**: `cuiqdata run examples/healthcare_claims`

#### **retail_inventory**

Inventory management and forecasting for retail operations.

- **Use case**: Track inventory levels, movements, and predict demand
- **Key features**:
  - Stock level ingestion across multiple locations
  - Inventory movement tracking
  - Demand forecasting
  - Low-stock alerts and reorder recommendations
- **Run**: `cuiqdata run examples/retail_inventory`

### Data Format Examples

#### **json_to_parquet**

Convert JSON data to Parquet format.

- **Use case**: Transform semi-structured JSON into columnar Parquet
- **Key features**:
  - JSON ingestion and flattening
  - Schema inference and type casting
  - Columnar export for analytical workloads
- **Run**: `cuiqdata run examples/json_to_parquet`

### Advanced Configuration Examples

#### **sql_pipeline**

Detailed SQL pipeline with explicit TOML configuration.

- **Uses**: sql_pipeline.toml with explicit metadata
- **Steps**: Ingest → Clean → Aggregate → Validate → Export
- **Demonstrates**:
  - Named TOML configuration
  - Timeout and scheduling settings
  - Multi-stage transformation patterns
- **Run**: `cuiqdata run examples/sql_pipeline`

### Database Integration Examples

#### **mysql_ingest.toml**, **mysql_orders_analysis.toml**, **mysql_to_postgres.toml**
Examples showing database connectivity and migration.
- Ingest data from MySQL
- Transform and analyze data
- Replicate data between databases
- Database-specific SQL patterns

#### **postgres_ingest.toml**
PostgreSQL ingestion and processing examples.
- Load data from PostgreSQL sources
- Demonstrate PostgreSQL-specific SQL functions
- Export transformed data

#### **test_metrics.toml**
Testing and metrics collection pipeline.
- Demonstrates metric aggregation
- Test result processing
- Reporting on pipeline health and performance

## Common Tasks

### Run a single example
```bash
cuiqdata run examples/simple_csv_processing
```

### Generate HTML report
```bash
cuiq report examples/ecommerce_orders
```

## Example Structure

Typical example directory contains:

```
example_name/
├── data/                    # Input data files (CSV, JSON, etc.)
├── output/                  # Generated output files
├── 001_*.sql               # SQL execution steps (numbered sequentially)
├── 00N_*.sql               
├── example_name.toml       # Optional: explicit pipeline configuration
├── README.md               # Detailed documentation
├── cache.db                # Generated: DuckDB cache
└── logs.db                 # Generated: Sqlite execution logs
```

## Adding New Examples

When creating a new example:

1. Create a directory under `examples/`
2. Create `data/` and `output/` subdirectories
3. Write numbered SQL files (001_*, 002_*, etc.)
4. Optionally create a TOML configuration file
5. Add a detailed README.md explaining:
   - Use case and business context
   - Pipeline steps and data flow
   - How to run the example
   - Expected outputs
   - Key SQL patterns demonstrated

## Prerequisites

- cuiqData binary built and in PATH
- For database examples: MySQL/PostgreSQL connection details configured
- For some examples: Python (generate_data.py scripts)

## Troubleshooting

### Example fails to run
- Check that cuiqData is properly built: `cuiq --version`
- Verify data files exist in `data/` directory
- Check logs.db for detailed error information

### Missing output files
- Check `output/` directory
- Review SQL export statements in final steps
- Check pipeline execution logs

### Database connection errors
- Verify database is running and accessible
- Check connection credentials in TOML files
- Ensure firewall allows connections

## Further Reading

- [cuiqData Documentation](../README.md)