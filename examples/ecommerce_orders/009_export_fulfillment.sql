-- Export fulfillment report to CSV for warehouse operations
-- Filename: fulfillment_report.csv
COPY fulfillment_report TO './output/fulfillment_report.csv' (FORMAT CSV, HEADER);
