-- Export aggregated claims metrics for payer analytics
COPY payer_report TO './output/payer_claims_summary.parquet' (FORMAT PARQUET);
