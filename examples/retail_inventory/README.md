# Retail Inventory & Supply Chain Pipeline

A comprehensive inventory management and supply chain pipeline for multi-warehouse retail operations. Tracks stock levels across locations, monitors inventory movements (sales, transfers, replenishment, damage), detects stock issues, and generates operational and analytics reports for inventory management and supply chain optimization.

## Use Case

This pipeline models a real retail supply chain workflow:
- **Multi-warehouse inventory tracking**: SKU-level quantities and states across distribution centers
- **Movement tracking**: Sales, replenishments, transfers, damage, and adjustments with full traceability
- **Stock health monitoring**: Out-of-stock detection, overstock identification, reorder point management
- **Data quality validation**: Negative quantities, missing reference data, inventory count age
- **Financial impact analysis**: Cost and retail value calculations, movement cost/revenue impact
- **Operational reporting**:
  - **Stock health report**: Aggregated metrics by warehouse and stock status
  - **Low stock alerts**: Items requiring immediate reordering
  - **Daily movement summary**: Sales, replenishment, and rebalancing activity
  - **Complete inventory**: Full enriched dataset for BI and analytics

## SQL Direct Mode Structure

This pipeline uses SQL Direct mode with numbered SQL files executed sequentially:

```
001_ingest_inventory.sql            # Load inventory from CSV
002_ingest_movements.sql            # Load movements from CSV
003_ingest_warehouses.sql           # Load warehouses from CSV
004_clean_inventory.sql             # Normalize inventory data
005_clean_movements.sql             # Normalize movement data
006_clean_warehouses.sql            # Normalize warehouse master data
007_enrich_inventory.sql            # Join and enrich with warehouse data
008_validate_inventory.sql          # Multi-condition validation
009_analyze_movements.sql           # Enrich movements with financial impact
010_generate_stock_health.sql       # Aggregate by warehouse and status
011_generate_daily_summary.sql      # Summarize daily movements
012_export_stock_health.sql         # Export summary metrics (CSV)
013_export_low_stock_alert.sql      # Export low/out-of-stock items (CSV)
014_export_daily_movements.sql      # Export movement summary (Parquet)
015_export_complete_inventory.sql   # Export full dataset (Parquet)
```

Optional metadata in `retail_inventory.toml` specifies pipeline name, description, timeout, and schedule.

## Pipeline Steps

1. **001 - ingest_inventory**: Load current inventory balances
2. **002 - ingest_movements**: Load inventory movements (sales, transfers, replenishment, damage)
3. **003 - ingest_warehouses**: Load warehouse master data
4. **004 - clean_inventory**: Normalize inventory data, calculate available quantities
5. **005 - clean_movements**: Normalize movement data, calculate signed quantities
6. **006 - clean_warehouses**: Normalize warehouse master data
7. **007 - enrich_inventory**: Join with warehouses, calculate financial values, determine stock status
8. **008 - validate_inventory**: 7-condition validation (missing fields, negative quantities, overdue counts)
9. **009 - analyze_movements**: Enrich movements with product info and financial impact
10. **010 - generate_stock_health**: Aggregate inventory by warehouse and stock status
11. **011 - generate_daily_summary**: Summarize daily movements by type and warehouse
12. **012 - export_stock_health**: Export summary metrics (CSV) for operations team
13. **013 - export_low_stock_alert**: Export low/out-of-stock items (CSV) for urgent action
14. **014 - export_daily_movements**: Export movement summary (Parquet) for analytics
15. **015 - export_complete_inventory**: Export complete enriched dataset (Parquet)

## Data Quality & Operational Issues Detected

The sample data includes intentional issues for validation demonstration:
- Missing product name (SKU010)
- Invalid unit cost (SKU010 has -$50.00)
- Invalid retail price (SKU010 has $0.00)
- Out-of-stock items (SKU002 at WH002, SKU006 at WH001)
- Low stock items (multiple SKUs below reorder points)
- Overdue inventory counts (SKU008 at WH002 missing count date)
- Invalid movements (MOV012 - zero quantity sale, MOV013 - invalid SKU, MOV014 - negative transfer)

## Stock Status Categories

- **out_of_stock**: Available quantity ≤ 0 (immediate reorder needed)
- **low_stock**: Available quantity < reorder point (order within lead time)
- **overstock**: Available quantity ≥ 3× reorder point (excess inventory)
- **normal**: Standard inventory level

## Movement Categories

- **customer**: Sales and customer-facing transactions
- **supplier**: Replenishments and purchase orders
- **internal**: Warehouse transfers and rebalancing
- **operational**: Damage, adjustments, inventory corrections
- **other**: Miscellaneous movements

## Running the Pipeline

```bash
cd examples/retail_inventory
cuiqdata run .
cuiqdata report .
```

The pipeline will execute all numbered SQL files sequentially, creating intermediate tables and exporting final results.

## Output

- **stock_health_report.csv**: Aggregated inventory metrics by warehouse and status
- **low_stock_alert.csv**: Items requiring immediate reordering with reorder points
- **daily_movements.parquet**: Daily movement summary with cost and revenue impact
- **complete_inventory.parquet**: Full inventory dataset with all enrichments

## Key SQL Patterns

- **Conditional quantity calculations**: CASE for signed quantities based on movement type
- **Financial impact analysis**: Cost and revenue calculations using unit economics
- **Window functions**: ROW_NUMBER for movement recency ranking
- **Stock categorization**: CASE expressions with threshold logic
- **Date calculations**: DATE_DIFF for inventory count age, days since last received
- **Complex LEFT JOINs**: Multi-table enrichment with inventory and warehouse data
- **Aggregations with multiple dimensions**: GROUP BY by warehouse, status, movement type
- **Data quality checks**: Negative values, missing references, overdue validations
- **COPY ... TO**: Export to CSV and Parquet formats
