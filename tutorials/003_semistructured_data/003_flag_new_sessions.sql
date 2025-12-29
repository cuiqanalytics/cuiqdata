-- LEVEL 3 - Step 3: Flag Session Boundaries
-- 
-- Goal:
--   Convert gap information into a boolean flag: IS THIS THE START OF A NEW SESSION?
-- 
-- Logic:
--   A new session starts if:
--   1. It's the FIRST event for a user (prev_timestamp IS NULL), OR
--   2. The gap since last event is > 30 minutes
-- 
-- CASE Expression:
--   CASE
--       WHEN condition THEN 1
--       ELSE 0
--   END
--   
--   This converts TRUE/FALSE into 1/0, which we can sum later.
--   Why 1/0 instead of TRUE/FALSE?
--     - Easier to aggregate (SUM, AVG, etc.)
--     - Works in all SQL engines
--     - More explicit: "count the 1's"
-- 
-- This Table Is Still Incremental:
--   We're adding a column (is_new_session), not transforming existing ones.
--   This makes the logic easy to verify and debug.
-- 

CREATE OR REPLACE TABLE events_with_flags AS
SELECT
    -- Copy all previous columns
    user_id,
    event_timestamp,
    url,
    prev_timestamp,
    minutes_since_last,
    
    -- New column: Is this the start of a session?
    CASE
        WHEN minutes_since_last IS NULL OR minutes_since_last > 30 THEN 1
        ELSE 0
    END AS is_new_session

FROM events_with_lag
ORDER BY user_id, event_timestamp;

-- Inspect: Mark the session starts clearly
-- SELECT 
--     user_id,
--     event_timestamp,
--     minutes_since_last,
--     is_new_session,
--     url
-- FROM events_with_flags
-- ORDER BY user_id, event_timestamp;

-- Show only session starts
-- SELECT 
--     user_id,
--     event_timestamp,
--     minutes_since_last,
--     url
-- FROM events_with_flags
-- WHERE is_new_session = 1
-- ORDER BY user_id, event_timestamp;

-- Statistics: How many session starts per user?
-- SELECT 
--     user_id,
--     COUNT(*) as total_events,
--     SUM(is_new_session) as session_starts
-- FROM events_with_flags
-- GROUP BY user_id
-- ORDER BY user_id;
