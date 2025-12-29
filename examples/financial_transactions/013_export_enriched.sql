-- Export all transactions with enrichments for audit and analysis
COPY transactions_enriched TO './output/all_transactions_enriched.parquet' (FORMAT PARQUET);
