# Simple CSV Processing Pipeline

This example shows the minimal setup needed for a SQL pipeline using just 001_*.sql files - no TOML configuration required.

## Files

- `001_load.sql` - Load CSV data
- `002_transform.sql` - Apply transformations
- `003_export.sql` - Export results

## Running

```bash
# From project root
cuiqdata run examples/simple_csv_processing
```

The pipeline will:
1. Auto-detect pipeline name as `simple_csv_processing` from directory name
2. Execute files in order: 001_, 002_, 003_
3. Generate sensible defaults (120 min timeout, etc.)

No sql_pipeline.toml needed!
