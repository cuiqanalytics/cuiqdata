/*
 * LEVEL 2 - Challenge Exercises
 * 
 * These exercises test your understanding of window functions
 * and sessionization logic.
 */

-- CHALLENGE 1: User Behavior Analysis
-- For each user, calculate:
--   - Total sessions
--   - Average pages per session
--   - Most common landing page (first page of a session)
-- Hint: Use session_summary table, GROUP BY user_id

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE user_behavior AS
-- SELECT ...


-- CHALLENGE 2: Session Duration Distribution
-- Categorize sessions by duration:
--   - "Quick" (< 5 minutes)
--   - "Medium" (5-15 minutes)
--   - "Long" (> 15 minutes)
-- Include session details and category.
-- Hint: Use CASE on session_duration_minutes

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE session_categories AS
-- SELECT ...


-- CHALLENGE 3: Bounce Rate Calculation
-- A "bounce" is a session with only 1 page view.
-- Calculate: bounce_count, total_sessions, bounce_rate_pct per user
-- Hint: COUNT(CASE WHEN page_views = 1 THEN 1 END)

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE bounce_analysis AS
-- SELECT ...


-- CHALLENGE 4: Time-Between-Sessions
-- For each user, calculate the time gap between consecutive sessions.
-- Hint: LAG() on session_end, PARTITION BY user_id

-- YOUR QUERY HERE:
-- WITH session_gaps AS (
--   SELECT ...
-- )
-- SELECT ...


-- CHALLENGE 5: Popular Landing Pages (Advanced)
-- Rank landing pages by frequency across all sessions.
-- A "landing page" is the first URL in a session.
-- Hint: Extract first URL per session, then GROUP BY url

-- YOUR QUERY HERE:
-- CREATE OR REPLACE TABLE popular_landing_pages AS
-- SELECT ...


/*
 * SOLUTIONS BELOW (Don't peek until you've tried!)
 */

-- ============ SOLUTION 1 ============
-- CREATE OR REPLACE TABLE user_behavior AS
-- SELECT
--     user_id,
--     COUNT(DISTINCT session_id) AS total_sessions,
--     ROUND(AVG(page_views), 2) AS avg_pages_per_session,
--     -- Get the most common landing page (first page of each session)
--     (SELECT url FROM user_sessions uw
--      WHERE uw.user_id = us.user_id
--      AND uw.event_timestamp = (
--          SELECT MIN(event_timestamp) FROM user_sessions 
--          WHERE user_id = uw.user_id AND session_id = uw.session_id
--      )
--      LIMIT 1) AS most_common_landing_page
-- FROM session_summary us
-- GROUP BY user_id;


-- ============ SOLUTION 2 ============
-- CREATE OR REPLACE TABLE session_categories AS
-- SELECT
--     user_id,
--     session_id,
--     session_start,
--     session_end,
--     session_duration_minutes,
--     page_views,
--     CASE
--         WHEN session_duration_minutes < 5 THEN 'Quick'
--         WHEN session_duration_minutes <= 15 THEN 'Medium'
--         ELSE 'Long'
--     END AS session_category
-- FROM session_summary
-- ORDER BY user_id, session_id;


-- ============ SOLUTION 3 ============
-- CREATE OR REPLACE TABLE bounce_analysis AS
-- SELECT
--     user_id,
--     COUNT(CASE WHEN page_views = 1 THEN 1 END) AS bounce_count,
--     COUNT(DISTINCT session_id) AS total_sessions,
--     ROUND(
--         100.0 * COUNT(CASE WHEN page_views = 1 THEN 1 END) / COUNT(DISTINCT session_id),
--         2
--     ) AS bounce_rate_pct
-- FROM session_summary
-- GROUP BY user_id
-- ORDER BY bounce_rate_pct DESC;


-- ============ SOLUTION 4 ============
-- WITH session_gaps AS (
--     SELECT
--         user_id,
--         session_id,
--         session_end,
--         LAG(session_end) OVER (PARTITION BY user_id ORDER BY session_id) AS prev_session_end,
--         date_diff('minute', 
--             LAG(session_end) OVER (PARTITION BY user_id ORDER BY session_id),
--             session_end
--         ) AS minutes_to_next_session
--     FROM session_summary
-- )
-- SELECT
--     user_id,
--     session_id,
--     session_end,
--     prev_session_end,
--     minutes_to_next_session
-- FROM session_gaps
-- WHERE prev_session_end IS NOT NULL
-- ORDER BY user_id, session_id;


-- ============ SOLUTION 5 ============
-- CREATE OR REPLACE TABLE popular_landing_pages AS
-- WITH landing_pages AS (
--     SELECT
--         user_id,
--         session_id,
--         FIRST_VALUE(url) OVER (
--             PARTITION BY user_id, session_id 
--             ORDER BY event_timestamp
--         ) AS landing_page
--     FROM user_sessions
-- )
-- SELECT
--     landing_page,
--     COUNT(*) AS session_count,
--     ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rank
-- FROM landing_pages
-- GROUP BY landing_page
-- ORDER BY rank;
