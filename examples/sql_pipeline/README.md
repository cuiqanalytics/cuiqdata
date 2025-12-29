# SQL Pipeline Example

This directory demonstrates the SQL file sequence feature of cuiqData.

## Structure

The pipeline consists of 5 sequential SQL files that are automatically discovered and chained:

1. **001_ingest.sql** - Load raw data from CSV
   - Type: Auto-detected as `ingest`
   - Output table: `0_ingest`

2. **002_clean.sql** - Clean and standardize data
   - Type: Auto-detected as `transform`
   - Input: `0_ingest` (from previous step)
   - Output table: `1_clean`

3. **003_aggregate.sql** - Create daily summary metrics
   - Type: Auto-detected as `transform`
   - Input: `1_clean`
   - Output table: `2_aggregate`

4. **004_validate.sql** - Quality checks
   - Type: Auto-detected as `validate`
   - Input: `2_aggregate`
   - Returns rows only if validation fails

5. **005_export.sql** - Export results
   - Type: Auto-detected as `sink` (last file)
   - Input: `2_aggregate`

## Optional Configuration

The `sql_pipeline.toml` file allows you to:
- Override the auto-detected pipeline name
- Set description and timeout
- Specify sink destinations

If not present, sensible defaults are used.

## Running the Pipeline

```bash
# From project root
cuiq run --sql examples/sql_pipeline

# Or with short flag
cuiq run examples/sql_pipeline -s
```

## Auto-Detection Rules

### Step Type Detection

Files are classified based on naming patterns:

- **ingest**: Contains "ingest" or "load", or is the first file
- **sink**: Contains "export" or "sink", or is the last file
- **validate**: Contains "validate" or "check"
- **transform**: Everything else

### Step Ordering

Files are sorted alphabetically by filename, so the numbered prefix (NNN_) ensures correct execution order:
- 001_ → executed first
- 002_ → executed second
- etc.

### Table Naming

Output tables are auto-generated from step names:
- Format: `{step_order}_{step_name}`
- Example: `001_ingest`, `002_clean`, `003_aggregate`

Steps automatically chain: the output of step N becomes the input of step N+1 (for transform and validate steps).

## Customization

### Using Different File Names

The only requirement is that filenames end with `.sql`. For example:
```
step_01_extract.sql
step_02_transform.sql
step_03_load.sql
```

Just make sure they sort alphabetically in the order you want them to execute.

### Adding More Steps

Simply add more SQL files following the naming convention:
```
006_archive.sql
007_cleanup.sql
```

### Metadata

Place `sql_pipeline.toml` in the same directory to provide pipeline metadata that overrides auto-detected values.

## Notes

- All SQL is executed in DuckDB
- Each step's output becomes the next step's input (auto-chained)
- Validation steps that return no rows are considered "passed"
- Sink steps don't produce output tables
- Table names are auto-generated; you can't customize them per-file
