# JSON to Parquet Pipeline

Convert JSONL event logs to Parquet with aggregation - no config file needed.

## Files

- `001_ingest.sql` - Load JSON Lines file
- `002_filter.sql` - Data validation and filtering
- `003_aggregate.sql` - Group events by day and type
- `004_export.sql` - Export aggregated results

## Running

```bash
cuiq run examples/json_to_parquet
```

Pipeline uses 001_*.sql naming convention without sql_pipeline.toml.
