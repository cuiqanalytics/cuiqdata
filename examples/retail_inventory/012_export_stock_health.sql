-- Export stock health metrics for operations team
COPY stock_health_report TO './output/stock_health_report.csv' (FORMAT CSV, HEADER);
