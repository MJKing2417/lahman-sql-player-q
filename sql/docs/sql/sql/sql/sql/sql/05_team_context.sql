/*
05_team_context.sql

Purpose:
Analyze team-level offensive environment
and player production within context.

Used for:
- Park/context adjustment
- Supporting valuation decisions
*/

WITH team_stats AS (
    SELECT
        teamID,
        yearID,
        SUM(AB) AS team_AB,
        SUM(HR) AS team_HR,
        SUM(H) AS team_H
    FROM Batting
    GROUP BY teamID, yearID
),

player_stats AS (
    SELECT
        playerID,
        teamID,
        yearID,
        SUM(AB) AS AB,
        SUM(HR) AS HR,
        SUM(H) AS H
    FROM Batting
    GROUP BY playerID, teamID, yearID
)

SELECT
    p.playerID,
    pe.nameFirst || ' ' || pe.nameLast AS player_name,
    p.teamID,
    p.yearID,

    ROUND(1.0 * p.H / NULLIF(p.AB,0), 3) AS player_avg,
    ROUND(1.0 * t.team_H / NULLIF(t.team_AB,0), 3) AS team_avg,

    ROUND(
        (1.0 * p.H / NULLIF(p.AB,0)) -
        (1.0 * t.team_H / NULLIF(t.team_AB,0)),
        3
    ) AS avg_vs_team

FROM player_stats p
JOIN team_stats t
  ON p.teamID = t.teamID
 AND p.yearID = t.yearID

JOIN People pe ON p.playerID = pe.playerID

WHERE p.AB >= 200
ORDER BY avg_vs_team DESC;
