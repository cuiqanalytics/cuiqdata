# E-Commerce Orders Processing Pipeline

A comprehensive order processing pipeline for an e-commerce business. Ingests orders and line items, performs data cleaning and enrichment, validates data quality, and generates fulfillment and analytics reports.

## Use Case

This pipeline demonstrates a real-world e-commerce order workflow:
- **Order ingestion**: Multiple CSV files with denormalized order data
- **Data cleaning**: Standardization, trimming, type normalization
- **Enrichment**: Computed fields, lookups, categorization (order tiers)
- **Validation**: Multi-stage data quality checks including amount mismatches
- **Reporting**: Two output formats for different consumers:
  - **Fulfillment report** (CSV): Warehouse operations team
  - **Order analytics** (Parquet): BI and analytics dashboards

## SQL Direct Mode Structure

This pipeline uses SQL Direct mode with numbered SQL files executed sequentially:

```
001_ingest_orders.sql           # Load raw orders from CSV
002_ingest_order_items.sql      # Load raw order line items from CSV
003_clean_orders.sql             # Standardize order data
004_clean_order_items.sql        # Standardize line item data
005_enrich_orders.sql            # Join and enrich with computed fields
006_validate_orders.sql          # Multi-condition data quality checks
007_generate_fulfillment_report.sql  # Create warehouse fulfillment instructions
008_generate_analytics.sql       # Aggregate metrics for analytics
009_export_fulfillment.sql       # Export fulfillment report as CSV
010_export_analytics.sql         # Export analytics as Parquet
```

Optional metadata in `ecommerce_orders.toml` specifies pipeline name, description, timeout, and schedule.

## Pipeline Steps

1. **001 - ingest_orders**: Load raw orders from CSV
2. **002 - ingest_order_items**: Load order line items from CSV
3. **003 - clean_orders**: Standardize order data (case, trim, type casting)
4. **004 - clean_order_items**: Standardize line item data and calculate computed totals
5. **005 - enrich_orders**: Join orders with aggregated line items, add order tier classification
6. **006 - validate_orders**: Multi-condition validation (missing fields, amount mismatches, address issues)
7. **007 - generate_fulfillment_report**: Create warehouse-friendly fulfillment instructions
8. **008 - generate_analytics**: Aggregate metrics by date, status, and order tier
9. **009 - export_fulfillment**: Export fulfillment report as CSV
10. **010 - export_analytics**: Export analytics as Parquet

## Data Quality Issues Detected

The sample data includes intentional issues for validation demonstration:
- Missing customer_id (ORD009)
- Negative total amount (ORD012) with non-refund status
- Failed orders with zero amounts (ORD005)
- Amount mismatches between headers and line items

## Running the Pipeline

```bash
cd examples/ecommerce_orders
cuiqdata run ecommerce_orders
```

The pipeline will execute all numbered SQL files sequentially, creating intermediate tables and exporting final results.

## Output

- **fulfillment_report.csv**: Warehouse operations use for order fulfillment
- **order_analytics.parquet**: BI team aggregated metrics for dashboards

## Key SQL Patterns

- **String normalization**: LOWER, UPPER, TRIM functions
- **Date handling**: DATE() casting, DATE_TRUNC() for aggregation
- **Aggregations**: GROUP BY with multiple dimensions
- **LEFT JOIN enrichment**: Matching orders with line item aggregations
- **CASE expressions**: Computed status fields (tier classification)
- **UNION ALL for validation**: Multi-condition quality checks
- **Date math**: ORDER BY with multiple sorting columns
- **COPY ... TO**: Export to CSV and Parquet formats
