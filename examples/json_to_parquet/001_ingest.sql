-- Load JSON file into DuckDB
CREATE TABLE raw_events AS
SELECT * FROM read_json_auto('./data/events.jsonl');
