/*
04_comps.sql

Purpose:
Generate comparable player profiles using rate statistics.

Used for:
- Player similarity analysis
- Valuation benchmarking
*/

WITH season_stats AS (
    SELECT
        b.playerID,
        b.yearID,
        SUM(b.AB) AS AB,
        SUM(b.HR) AS HR,
        SUM(b.BB) AS BB,
        SUM(b.H) AS H
    FROM Batting b
    GROUP BY b.playerID, b.yearID
),

rates AS (
    SELECT
        playerID,
        yearID,
        ROUND(1.0 * H  / NULLIF(AB,0), 3) AS avg,
        ROUND(1.0 * HR / NULLIF(AB,0), 4) AS hr_rate,
        ROUND(1.0 * BB / NULLIF(AB,0), 4) AS bb_rate
    FROM season_stats
    WHERE AB >= 200
)

SELECT
    r1.playerID AS target_player,
    p1.nameFirst || ' ' || p1.nameLast AS target_name,
    r2.playerID AS comp_player,
    p2.nameFirst || ' ' || p2.nameLast AS comp_name,
    r1.yearID,

    ROUND(
        ABS(r1.avg - r2.avg) +
        ABS(r1.hr_rate - r2.hr_rate) +
        ABS(r1.bb_rate - r2.bb_rate),
        4
    ) AS similarity_score

FROM rates r1
JOIN rates r2
  ON r1.yearID = r2.yearID
 AND r1.playerID <> r2.playerID

JOIN People p1 ON r1.playerID = p1.playerID
JOIN People p2 ON r2.playerID = p2.playerID

ORDER BY similarity_score ASC
LIMIT 100;
