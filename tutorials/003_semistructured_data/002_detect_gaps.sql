-- LEVEL 3 - Step 2: Detect Time Gaps (Window Functions)
-- 
-- Goal:
--   For each user, calculate the time since their last click.
--   This is the foundation for sessionization.
-- 
-- Window Functions Explained:
--   LAG(column) OVER (PARTITION BY user_id ORDER BY timestamp)
--   
--   - PARTITION BY user_id: Restart the window for each user
--   - ORDER BY timestamp: Process events in chronological order
--   - LAG(): Look at the PREVIOUS row's value
--   
--   Result: Each row knows the timestamp of the previous click.
-- 
-- Why LAG() Instead of JOIN?
--   - Without LAG, you'd need: JOIN raw_events AS prev ON ... (expensive!)
--   - LAG is a single-pass algorithm: it scans data once
--   - For large datasets, this is orders of magnitude faster
-- 
-- Edge Case:
--   The first event for a user has NO previous event.
--   LAG() returns NULL for the first row. That's intentional.

CREATE OR REPLACE TABLE events_with_lag AS
SELECT
    -- Identifiers: Which user, which event
    user_id,
    event_timestamp,
    url,
    
    -- Window function: Get the PREVIOUS event's timestamp for this user
    LAG(event_timestamp) OVER (
        PARTITION BY user_id 
        ORDER BY event_timestamp
    ) AS prev_timestamp,
    
    -- Calculate the gap in minutes
    -- date_diff('minute', prev_timestamp, event_timestamp) returns NULL if prev_timestamp is NULL
    date_diff('minute', 
        LAG(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp),
        event_timestamp
    ) AS minutes_since_last

FROM raw_events
ORDER BY user_id, event_timestamp;

-- Inspect results: Do we see gaps?
-- SELECT * FROM events_with_lag LIMIT 20;

-- Show some interesting gaps (where minutes_since_last > 30)
-- SELECT user_id, event_timestamp, prev_timestamp, minutes_since_last
-- FROM events_with_lag
-- WHERE minutes_since_last > 30
-- ORDER BY user_id, event_timestamp;

-- Summary: How many events start a new session?
-- SELECT 
--     COUNT(*) as total_events,
--     COUNT(CASE WHEN minutes_since_last IS NULL THEN 1 END) as first_events,
--     COUNT(CASE WHEN minutes_since_last > 30 THEN 1 END) as gap_based_session_starts
-- FROM events_with_lag;
