-- Export complete inventory with all enrichments for analytics
COPY inventory_enriched TO './output/complete_inventory.parquet' (FORMAT PARQUET);
