-- Export summary as Parquet file
COPY daily_event_summary TO './output/event_summary.parquet';
