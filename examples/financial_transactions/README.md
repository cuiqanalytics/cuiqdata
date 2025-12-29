# Financial Services - Transaction & Compliance Pipeline

A comprehensive financial transaction processing pipeline for AML (Anti-Money Laundering) compliance and risk management. Ingests transactions with account and counterparty data, performs KYC/AML validations, detects suspicious patterns, and generates compliance reports for regulators and risk teams.

## Use Case

This pipeline models a real financial services transaction monitoring workflow:
- **Multi-source ingestion**: Transactions, account master data, counterparty information
- **Data normalization**: Case standardization, timestamp construction, signed amount calculation
- **KYC/AML enrichment**: Account verification status, counterparty risk flags, jurisdiction risk categorization
- **Compliance validation**: Unverified accounts, sanctions list matching, cross-border transfer risk
- **Suspicious pattern detection**: Rule-based risk scoring, large transfer detection, multi-factor analysis
- **Regulatory reporting**:
  - **Suspicious Activity Report**: Flagged transactions for manual review
  - **Compliance Summary**: Aggregated metrics by jurisdiction and risk level
  - **Audit Trail**: Full enriched transaction dataset

## SQL Direct Mode Structure

This pipeline uses SQL Direct mode with numbered SQL files executed sequentially:

```
001_ingest_transactions.sql     # Load transactions from CSV
002_ingest_accounts.sql         # Load account master data
003_ingest_counterparties.sql   # Load counterparty data
004_clean_transactions.sql      # Normalize transaction data
005_clean_accounts.sql          # Standardize account metadata
006_clean_counterparties.sql    # Standardize counterparty data
007_enrich_transactions.sql     # Join and enrich with compliance flags
008_validate_transactions.sql   # Multi-condition KYC/AML validation
009_detect_suspicious_patterns.sql  # Rule-based pattern detection
010_generate_compliance_summary.sql # Aggregate metrics by dimension
011_export_suspicious.sql       # Export flagged transactions (CSV)
012_export_compliance.sql       # Export summary metrics (Parquet)
013_export_enriched.sql         # Export full dataset (Parquet)
```

Optional metadata in `financial_transactions.toml` specifies pipeline name, description, timeout, and schedule.

## Pipeline Steps

1. **001 - ingest_transactions**: Load transaction data from CSV
2. **002 - ingest_accounts**: Load account master with AML/KYC status
3. **003 - ingest_counterparties**: Load counterparty data with sanctions status
4. **004 - clean_transactions**: Normalize transaction data, calculate signed amounts
5. **005 - clean_accounts**: Standardize account metadata
6. **006 - clean_counterparties**: Standardize counterparty data with jurisdiction risk classification
7. **007 - enrich_transactions**: Join with account and counterparty data, compute compliance flags
8. **008 - validate_transactions**: 7-condition validation (missing fields, unverified accounts, sanctions)
9. **009 - detect_suspicious_patterns**: Rule-based pattern detection with risk scoring (0-85 scale)
10. **010 - generate_compliance_summary**: Aggregate metrics by day, jurisdiction, and risk level
11. **011 - export_suspicious**: Export flagged transactions (CSV) for compliance team
12. **012 - export_compliance**: Export summary metrics (Parquet) for regulators
13. **013 - export_enriched**: Export full dataset (Parquet) for audit

## Data Quality & Compliance Issues Detected

The sample data includes intentional issues for validation demonstration:
- Missing account_id (TXN009)
- Missing counterparty_id (TXN013)
- Zero-amount transaction (TXN007)
- Unverified KYC account making large transactions (ACC007)
- Sanctioned entity (CP011 - Offshore Bank marked as flagged)
- High-risk jurisdiction transactions (Dubai, Hong Kong, Panama)
- Structuring pattern (TXN005 - $250k pending review, TXN015 - $150k flagged)
- Negative deposit amounts indicating chargebacks (TXN012)

## Risk Scoring

Risk scores (0-85 scale) include:
- **85**: Large transfer to high-risk counterparty
- **70**: Large transaction from unverified account
- **60**: High-risk counterparty transaction
- **50**: High-risk jurisdiction transfer
- **40**: System-flagged transaction
- **10**: Exceeds monthly volume limit
- **0**: Routine transaction

## Running the Pipeline

```bash
cd examples/financial_transactions
cuiqdata run .
cuiqdata report .
```

The pipeline will execute all numbered SQL files sequentially, creating intermediate tables and exporting final results.

## Output

- **suspicious_transactions.csv**: Transactions requiring compliance review, ranked by risk score
- **compliance_summary.parquet**: Aggregated metrics by day and jurisdiction
- **all_transactions_enriched.parquet**: Complete audit trail with all enrichment fields

## Key SQL Patterns

- **Date/timestamp handling**: CAST, CONCAT, DATE_TRUNC
- **Signed amount calculation**: CASE expressions for transaction direction
- **Risk classification**: Multi-condition CASE for jurisdiction and entity risk
- **Complex boolean flags**: Multiple enrichment flags for downstream detection
- **LEFT JOIN enrichment**: Multi-table enrichment with account and counterparty data
- **Risk scoring**: Rule-based scoring with weighted conditions
- **UNION ALL for validation**: Multi-condition quality checks
- **Aggregations with GROUP BY**: Compliance metrics by dimension
- **Pattern detection**: Boolean logic across multiple risk factors
- **COPY ... TO**: Export to CSV and Parquet formats
