-- Export order analytics to Parquet for BI dashboards
-- Filename: order_analytics.parquet
COPY order_analytics TO './output/order_analytics.parquet' (FORMAT PARQUET);
