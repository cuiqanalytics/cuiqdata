-- Export compliance metrics and summary statistics
COPY compliance_summary TO './output/compliance_summary.parquet' (FORMAT PARQUET);
