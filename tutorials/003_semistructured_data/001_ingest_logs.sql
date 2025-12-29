-- LEVEL 3 - Step 1: Ingest Event Logs (JSON)
-- 
-- Goal:
--   Load semi-structured JSON data. Real applications ship events as JSON streams.
--   We'll flatten them into a queryable table.
-- 
-- JSON vs. Relational Data:
--   - JSON is flexible: Different events can have different fields.
--   - Relational tables are rigid: Every row must have same structure.
--   - Our job: Ingest JSON, extract what matters, create consistent rows.
-- 
-- DuckDB's read_json_auto():
--   Like read_csv_auto() but for JSON. It detects nested structures
--   and creates columns. For complex JSON, you may need to manually
--   flatten using JSON operators (json_extract, etc.).

CREATE OR REPLACE TABLE raw_events AS
SELECT 
    * 
FROM read_json_auto('./data/sample_events.jsonl');

-- Quick inspection: what data do we have?
-- SELECT 
--     COUNT(*) as total_events,
--     COUNT(DISTINCT user_id) as unique_users,
--     MIN(event_timestamp) as earliest_event,
--     MAX(event_timestamp) as latest_event
-- FROM raw_events;

-- Sample a few rows to verify structure
-- SELECT * FROM raw_events LIMIT 5;
