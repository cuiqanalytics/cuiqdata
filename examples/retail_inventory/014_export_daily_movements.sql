-- Export daily movement summary for supply chain analytics
COPY daily_movement_summary TO './output/daily_movements.parquet' (FORMAT PARQUET);
