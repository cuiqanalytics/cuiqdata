-- Export all claims with enrichments for comprehensive analysis
COPY claims_enriched TO './output/all_claims_enriched.parquet' (FORMAT PARQUET);
