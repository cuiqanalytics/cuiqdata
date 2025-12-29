# Healthcare Claims Processing Pipeline

A comprehensive insurance claims processing pipeline demonstrating data quality checks and financial reconciliation in healthcare. Ingests claims, procedures, and patient data; validates medical necessity and billing rules; and generates reports for claim payment, denial analysis, and payer analytics.

## Use Case

This pipeline models a real healthcare claims processing workflow:
- **Multi-source ingestion**: Claims, procedures, and patient demographics
- **Data normalization**: Case standardization, type casting, date handling
- **Financial enrichment**: Contractual adjustments, patient responsibility, payment gaps
- **Claims categorization**: Severity levels, value tiers, denial categories
- **Comprehensive validation**: Medical necessity, billing logic, data consistency
- **Multi-stakeholder reporting**:
  - **Payer reports**: Aggregated metrics for financial planning
  - **Denial analysis**: Categorized denials for manual review and appeals
  - **Complete dataset**: All enriched claims for comprehensive analytics

## SQL Direct Mode Structure

This pipeline uses SQL Direct mode with numbered SQL files executed sequentially:

```
001_ingest_claims.sql           # Load claims from CSV
002_ingest_procedures.sql       # Load procedures from CSV
003_ingest_patients.sql         # Load patients from CSV
004_clean_claims.sql            # Normalize claim data
005_clean_procedures.sql        # Normalize procedures
006_clean_patients.sql          # Normalize patients
007_enrich_claims.sql           # Join and enrich with computed fields
008_validate_claims.sql         # Multi-condition validation
009_generate_payer_report.sql   # Aggregate claims by status/severity
010_generate_denial_analysis.sql # Extract denied/pending claims
011_export_payer_report.sql     # Export metrics (Parquet)
012_export_denials.sql          # Export denials (CSV)
013_export_all_claims.sql       # Export full dataset (Parquet)
```

Optional metadata in `healthcare_claims.toml` specifies pipeline name, description, timeout, and schedule.

## Pipeline Steps

1. **001 - ingest_claims**: Load raw insurance claims from CSV
2. **002 - ingest_procedures**: Load procedure codes and charges
3. **003 - ingest_patients**: Load patient demographics
4. **004 - clean_claims**: Standardize and type-cast claim data
5. **005 - clean_procedures**: Standardize procedure information
6. **006 - clean_patients**: Standardize patient demographics and compute age
7. **007 - enrich_claims**: Join with procedures/patients, calculate financial metrics
8. **008 - validate_claims**: 8-condition data quality validation (missing fields, amount mismatches, date logic)
9. **009 - generate_payer_report**: Aggregate claims by status, severity, plan type
10. **010 - generate_denial_analysis**: Extract and categorize denied/pending claims
11. **011 - export_payer_report**: Export aggregated metrics as Parquet
12. **012 - export_denials**: Export denied claims as CSV for manual review
13. **013 - export_all_claims**: Export full enriched dataset as Parquet

## Data Quality Issues Detected

The sample data includes intentional issues for validation demonstration:
- Missing member_id (CLM007) - Invalid member ID
- Missing provider_id (CLM009)
- Missing copay value (CLM013)
- Zero claim amount with approval status (CLM014)
- Negative claim amount with non-refund status (CLM011) - Actually valid drug refund
- Payment mismatch between amounts and components

## Key Domain Concepts

- **Allowed Amount**: Contractually agreed amount between payer and provider
- **Contractual Adjustment**: Difference between billed and allowed amounts
- **Copay/Coinsurance**: Patient's financial responsibility
- **Plan Payment Gap**: Amount not accounted for in paid + patient responsibility
- **Claim Severity**: Routine vs. Urgent vs. Pharmacy
- **Value Category**: High-value claims requiring additional scrutiny
- **Denial Categories**: Documentation, data quality, business rule violations

## Running the Pipeline

```bash
cd examples/healthcare_claims
cuiqdata run .
cuiqdata report .
```

The pipeline will execute all numbered SQL files sequentially, creating intermediate tables and exporting final results.

## Output

- **payer_claims_summary.parquet**: Aggregated metrics by status, severity, and plan type
- **denied_claims.csv**: Claims requiring manual review with denial reasons
- **all_claims_enriched.parquet**: Complete dataset with all computed fields

## Key SQL Patterns

- **Date calculations**: DATE_DIFF for days to claim, date comparison logic
- **Financial calculations**: Rounding, payment reconciliation, gap analysis
- **Complex joins**: LEFT JOIN with multi-source enrichment
- **CASE expressions**: Severity/value categorization, denial categorization
- **UNION ALL for validation**: Multi-condition quality checks with specific issue identification
- **Aggregations with GROUP BY**: Claims summarization by multiple dimensions
- **CAST/COALESCE**: Type handling and null value defaults
- **COPY ... TO**: Export to CSV and Parquet formats
