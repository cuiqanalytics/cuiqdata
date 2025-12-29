-- LEVEL 2 - Step 4: Export Report
-- 
-- Goal:
--   Take the gold-layer metrics and deliver them to stakeholders
--   in formats they can use immediately.
-- 
-- Why Export?
--   - CSV can be opened in Excel, Google Sheets, or Power BI
--   - Parquet is a compressed columnar format, great for archival and analytics tools
--   - Having the report file makes it easy to share, version, and audit
-- 
-- Formats Explained:
--   - CSV: Human-readable, universal, but larger file size and slower for big data
--   - Parquet: Binary, compressed, preserves types, ideal for modern BI tools
-- 

-- Export as CSV for business users (Excel, sheets)
-- IMPORTANT: Ensure the './output/' directory exists before running this.
COPY city_revenue_stats 
TO './output/city_revenue_report.csv' 
(HEADER, DELIMITER ',');

-- Export as Parquet for archival and BI tools (Power BI, Tableau)
COPY city_revenue_stats 
TO './output/city_revenue_report.parquet' 
(FORMAT PARQUET);

-- Tip: Ensure the './output/' directory exists before running this.
-- In a real pipeline, you'd create it if needed:
-- CREATE DIRECTORY './output' (if your DB supports it)
-- or use shell: mkdir -p ./output

-- Optional: Create a human-friendly summary report as HTML
-- (For advanced users: consider using a reporting tool like Apache Superset)

-- Final verification: how many rows did we export?
-- SELECT 
--     COUNT(*) as cities_in_report,
--     SUM(total_revenue) as grand_total_revenue
-- FROM city_revenue_stats;
