/*
03_age_curves.sql

Purpose:
Analyze average offensive production by player age.

Used for:
- Aging curve analysis
- Projection baselines
*/

WITH player_age AS (
    SELECT
        b.playerID,
        b.yearID,
        (b.yearID - p.birthYear) AS age,
        SUM(b.AB) AS AB,
        SUM(b.HR) AS HR,
        SUM(b.H) AS H
    FROM Batting b
    JOIN People p ON b.playerID = p.playerID
    WHERE p.birthYear IS NOT NULL
    GROUP BY b.playerID, b.yearID
),

rates AS (
    SELECT
        age,
        SUM(AB) AS total_AB,
        SUM(HR) AS total_HR,
        SUM(H) AS total_H,
        ROUND(1.0 * SUM(H) / NULLIF(SUM(AB),0), 3) AS avg,
        ROUND(1.0 * SUM(HR) / NULLIF(SUM(AB),0), 4) AS hr_rate
    FROM player_age
    WHERE AB >= 200
    GROUP BY age
)

SELECT
    age,
    total_AB,
    avg,
    hr_rate
FROM rates
WHERE age BETWEEN 18 AND 42
ORDER BY age;
