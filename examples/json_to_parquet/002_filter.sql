-- Filter and clean events data
CREATE TABLE filtered_events AS
SELECT
  event_id,
  event_type,
  user_id,
  event_timestamp,
  event_data
FROM raw_events
WHERE event_type IS NOT NULL
  AND user_id IS NOT NULL
  AND event_timestamp IS NOT NULL;
