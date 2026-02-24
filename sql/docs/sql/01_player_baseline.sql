/*
01_player_baseline.sql

Purpose:
Create a baseline table of player offensive performance
combined with salary and demographic data.

Used for:
- Establishing player value benchmarks
- Comparing production vs compensation
*/

SELECT
    p.playerID,
    p.nameFirst || ' ' || p.nameLast AS player_name,
    b.yearID,
    b.teamID,
    b.AB,
    b.H,
    b.HR,
    b.RBI,
    b.BB,
    b.SO,
    ROUND(1.0 * b.H / NULLIF(b.AB, 0), 3) AS batting_avg,
    s.salary,
    (b.HR * 1.0 / NULLIF(b.AB, 0)) AS hr_rate,
    (b.BB * 1.0 / NULLIF(b.AB, 0)) AS bb_rate
FROM Batting b
JOIN People p ON b.playerID = p.playerID
LEFT JOIN Salaries s
    ON b.playerID = s.playerID
   AND b.yearID = s.yearID
WHERE b.AB >= 200
ORDER BY b.yearID DESC, b.HR DESC;
