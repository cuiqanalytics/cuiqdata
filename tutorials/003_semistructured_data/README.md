# Level 3: The Data Engineer (SaaS Sessionization)

## Overview

In this tutorial, you'll solve a **hard problem**: grouping user interactions into sessions based on time gaps. This is a classic data engineering pattern used in web analytics, fraud detection, and user behavior analysis.

## Prerequisites

- cuiqData installed and working
- Basic terminal/command line skills
- Completion of **Level 2** (or familiarity with `CREATE TABLE`, `SELECT`, `FROM`)

## Learning Goals

- Master **Window Functions** (`LAG`, `SUM() OVER()`) for sequential analysis
- Understand **gap-based grouping**: a fundamental technique in analytics
- Learn **Star Schema** design for scalability
- Build logic flags and cumulative sums for complex grouping
- Handle JSON data with `read_json_auto()`

## Scenario

You work at a SaaS company. You have JSON logs of user clicks with timestamps. Your task is to group clicks into "sessions" where a session ends if the user is inactive for 30+ minutes.

**Example:**
```
User A clicks at: 10:00, 10:05, 10:08        → Session 1
User A clicks at: 10:45                       → Session 2 (gap > 30 mins)
User B clicks at: 10:02, 10:03                → Session 1
```

## Key Concepts Covered

| Concept | Why It Matters |
|---------|---|
| **Window Functions** | `LAG()`, `SUM() OVER()` let you compare rows without expensive joins. Essential for fast analytics. |
| **Gap Detection** | Real-world data is messy. Sessions aren't labeled—you calculate them. |
| **Cumulative Aggregates** | `SUM(flag) OVER()` converts state changes into group IDs. Powerful and elegant. |
| **JSON Parsing** | Modern systems ship data as JSON. Learn to flatten it into queryable tables. |
| **Star Schema Prelude** | A session_id table + facts table = efficient, queryable design. |

## Data

You'll need a JSON Lines file at `data/sample_events.jsonl` with user interactions (one JSON object per line):
```json
{"user_id":"user_123","event_timestamp":"2024-01-15T10:00:00Z","url":"/home"}
{"user_id":"user_123","event_timestamp":"2024-01-15T10:05:00Z","url":"/products"}
{"user_id":"user_123","event_timestamp":"2024-01-15T10:08:00Z","url":"/cart"}
{"user_id":"user_456","event_timestamp":"2024-01-15T10:02:00Z","url":"/home"}
```

## How to Use This Tutorial

1. Open a terminal and navigate to this directory:
   ```bash
   cd tutorials/003_semistructured_data
   ```

2. Ensure you have `data/sample_events.jsonl` with sample user events

3. Run the SQL files in order:
   ```bash
   cuiqdata run 001_ingest_logs.sql
   cuiqdata run 002_detect_gaps.sql
   cuiqdata run 003_flag_new_sessions.sql
   cuiqdata run 004_assign_session_ids.sql
   ```

4. Read the comments carefully to understand `LAG()` and window functions

5. Study `003_flag_new_sessions.sql` to see how logic flags work

6. Learn the cumulative sum trick in `004_assign_session_ids.sql`

7. Complete the challenge to apply your knowledge

## Best Practices

✓ Use `PARTITION BY` to keep calculations scoped to one user  
✓ Window functions replace expensive self-joins  
✓ Cumulative sums create unique identifiers automatically  
✓ Comment every window function—they're powerful but confusing  

## Advanced Topics (After Mastery)

- **Star schemas**: Dimension tables (users, sessions) + fact tables (events)
- **Sessionization variants**: Based on URL path changes, device changes, etc.
- **Incremental updates**: How to recalculate only new events
- **Real-time sessions**: Computing sessions as events stream in

## Files in This Tutorial

- **001_ingest_logs.sql** - Load JSON events
- **002_detect_gaps.sql** - Calculate time deltas with `LAG()`
- **003_flag_new_sessions.sql** - Identify session boundaries
- **004_assign_session_ids.sql** - Create session IDs
- **challenge.sql** - Hands-on exercises
