/*
02_breakout_candidates.sql

Purpose:
Identify hitters with significant year-over-year improvement
in power and on-base skills.

Used for:
- Breakout candidate identification
- Development monitoring
*/

WITH yearly_stats AS (
    SELECT
        playerID,
        yearID,
        SUM(AB) AS AB,
        SUM(HR) AS HR,
        SUM(BB) AS BB,
        SUM(H) AS H
    FROM Batting
    GROUP BY playerID, yearID
),

rates AS (
    SELECT
        playerID,
        yearID,
        AB,
        HR,
        BB,
        H,
        ROUND(1.0 * HR / NULLIF(AB,0), 4) AS hr_rate,
        ROUND(1.0 * BB / NULLIF(AB,0), 4) AS bb_rate,
        ROUND(1.0 * H  / NULLIF(AB,0), 4) AS avg
    FROM yearly_stats
    WHERE AB >= 150
),

lagged AS (
    SELECT
        r1.*,
        r2.hr_rate AS prev_hr_rate,
        r2.bb_rate AS prev_bb_rate,
        r2.avg AS prev_avg
    FROM rates r1
    LEFT JOIN rates r2
      ON r1.playerID = r2.playerID
     AND r1.yearID = r2.yearID + 1
)

SELECT
    l.playerID,
    p.nameFirst || ' ' || p.nameLast AS player_name,
    l.yearID,
    l.hr_rate,
    l.prev_hr_rate,
    ROUND(l.hr_rate - l.prev_hr_rate, 4) AS hr_rate_delta,
    l.bb_rate,
    l.prev_bb_rate,
    ROUND(l.bb_rate - l.prev_bb_rate, 4) AS bb_rate_delta,
    l.avg,
    l.prev_avg
FROM lagged l
JOIN People p ON l.playerID = p.playerID
WHERE l.prev_hr_rate IS NOT NULL
  AND (l.hr_rate - l.prev_hr_rate) >= 0.015
ORDER BY hr_rate_delta DESC;
