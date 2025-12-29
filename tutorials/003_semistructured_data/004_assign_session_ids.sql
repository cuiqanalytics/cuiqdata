-- LEVEL 3 - Step 4: Assign Session IDs (The Clever Trick)
-- 
-- Goal:
--   Convert session-start flags into unique session IDs.
--   We want each session to have a distinct ID so we can group events.
-- 
-- The Cumulative Sum Trick:
--   SUM(is_new_session) OVER (PARTITION BY user_id ORDER BY event_timestamp)
--   
--   This runs a cumulative sum of the is_new_session flag.
--   - First event: is_new_session=1, cumsum=1  ← Session 1
--   - Second event: is_new_session=0, cumsum=1 ← Still Session 1
--   - Third event: is_new_session=1, cumsum=2  ← Session 2 starts
--   - Fourth event: is_new_session=0, cumsum=2 ← Still Session 2
--   
--   The cumulative sum ONLY increases when we hit a new session.
--   Therefore, all events in a session have the same cumsum value = session ID!
-- 
-- Why This Works:
--   - It's deterministic: Same input, same session IDs
--   - It's order-preserving: Events stay in sequence
--   - It scales: Works for millions of users and events
--   - It's composable: You can calculate metrics per session now
-- 
-- Real-World Analogy:
--   Imagine a teacher marking papers with pen. Each time they finish a student's
--   paper, they write down a number. When they move to the next student, they
--   increment the number. All pages of one student's work have the same number. 

CREATE OR REPLACE TABLE user_sessions AS
SELECT
    user_id,
    event_timestamp,
    url,
    
    -- The magic: Cumulative sum creates unique session IDs per user
    SUM(is_new_session) OVER (
        PARTITION BY user_id 
        ORDER BY event_timestamp
    ) AS session_id,
    
    -- Keep the flags for debugging
    minutes_since_last,
    is_new_session

FROM events_with_flags
ORDER BY user_id, session_id, event_timestamp;

-- Inspect: Each session has a unique ID
-- SELECT 
--     user_id,
--     session_id,
--     event_timestamp,
--     url
-- FROM user_sessions
-- LIMIT 30;

-- Show one user's sessions
-- SELECT DISTINCT
--     user_id,
--     session_id,
--     MIN(event_timestamp) as session_start,
--     MAX(event_timestamp) as session_end,
--     COUNT(*) as events_in_session
-- FROM user_sessions
-- WHERE user_id = (SELECT user_id FROM user_sessions LIMIT 1)
-- GROUP BY user_id, session_id
-- ORDER BY session_id;

-- Aggregate session stats
CREATE OR REPLACE TABLE session_summary AS
SELECT
    user_id,
    session_id,
    MIN(event_timestamp) AS session_start,
    MAX(event_timestamp) AS session_end,
    date_diff('minute', MIN(event_timestamp), MAX(event_timestamp)) AS session_duration_minutes,
    COUNT(*) AS page_views,
    COUNT(DISTINCT url) AS unique_pages,
    STRING_AGG(url, ' → ') AS user_journey
FROM user_sessions
GROUP BY user_id, session_id
ORDER BY user_id, session_id;

-- SELECT * FROM session_summary LIMIT 20;
