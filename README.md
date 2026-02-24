# Lahman SQL Player Queries

A curated set of SQL queries using the Lahman Baseball Database to support player analysis:
- baselines
- aging curves
- breakout candidates
- comps (similar player profiles)
- team/context adjustments

## Contents
- `sql/` — core queries
- `docs/` — explanation + example outputs

## How to use
1. Download the Lahman database (CSV or SQLite).
2. Load it into SQLite or Postgres.
3. Run queries from the `sql/` folder.

## Query Index
- `01_player_baseline.sql` — baseline player performance table
- `02_breakout_candidates.sql` — identify potential breakouts
- `03_age_curves.sql` — aging curve analysis
- `04_comps.sql` — player comparisons
- `05_team_context.sql` — team/context splits

## Roadmap
- Add SQLite setup script
- Add example outputs and charts
- Add parameterized queries
