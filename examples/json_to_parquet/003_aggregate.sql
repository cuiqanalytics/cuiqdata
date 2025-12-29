-- Aggregate events by type and day
CREATE TABLE daily_event_summary AS
SELECT
  DATE_TRUNC('day', event_timestamp) as event_date,
  event_type,
  COUNT(*) as event_count,
  COUNT(DISTINCT user_id) as unique_users
FROM filtered_events
GROUP BY DATE_TRUNC('day', event_timestamp), event_type
ORDER BY event_date DESC, event_count DESC;
