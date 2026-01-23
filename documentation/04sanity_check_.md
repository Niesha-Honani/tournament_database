# Sanity Check Walkthrough (sanity_check.sql)
*Goal: A sanity check script is a quick “preflight inspection” for your database.
It answers: Did my schema load? Did my seed load? Are relationships/constraints actually there?*

This is the file you run when you want confidence before writing queries, building APIs, or debugging tests.

## 1. Confirm DB + Schema
```
SELECT current_database();
SELECT current_schema();
```
Why this matters

A huge percentage of “my seed didn’t load” bugs are actually:

connected to the wrong DB name

connected to the wrong schema (less common early, but real in teams)

✅ These two lines give you instant proof.

---
## 2. Validates Row Counts (Did Seed Data Load?)
```
SELECT 'tournament'    AS table, COUNT(*) FROM tournament
UNION ALL SELECT 'teams',       COUNT(*) FROM teams
UNION ALL SELECT 'players',     COUNT(*) FROM players
UNION ALL SELECT 'tourney_teams', COUNT(*) FROM tourney_teams
UNION ALL SELECT 'teamroster',  COUNT(*) FROM teamroster
UNION ALL SELECT 'rounds',      COUNT(*) FROM rounds
UNION ALL SELECT 'matches',     COUNT(*) FROM matches
UNION ALL SELECT 'matchresults', COUNT(*) FROM matchresults
UNION ALL SELECT 'playerstats', COUNT(*) FROM playerstats
UNION ALL SELECT 'playermatchstats', COUNT(*) FROM playermatchstats;
```
What this check does

It verifies each key table exists and contains rows

It catches “seed script didn’t run” in ~2 seconds

**sanity checks shouldn’t require you to “remember what you seeded.” Put expected counts as comments next to each line if you want it classroom-friendly.**

---
## 3. Discover Relationships via Foreign Keys (Metadata Query)

```
SELECT
  tc.table_name AS child_table,
  kcu.column_name AS child_column,
  ccu.table_name AS parent_table,
  ccu.column_name AS parent_column,
  tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY child_table;
```

### Why this is powerful

This prints a human-readable list of:

* which table depends on which

* which column is the foreign key

* what constraint name enforces it

*this query tells you what relationships exist*

___
## 4. Inspect UNIQUE Constraints (Data Integrity Rules)

```
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid IN (
  'rounds'::regclass,
  'teamroster'::regclass,
  'tourney_teams'::regclass,
  'playerstats'::regclass,
  'playermatchstats'::regclass,
  'matchresults'::regclass
)
ORDER BY conrelid::regclass::text, conname;

```
### What this does


This checks your rules, not just your data.

Useful UNIQUE constraints include:

* rounds: UNIQUE(tournament_id, round_number)

* teamroster: UNIQUE(tourney_id, player_id)

* tourney_teams: UNIQUE(tourney_id, team_id)

* playerstats: UNIQUE(player_id, tournament_id)

* playermatchstats: composite PK (match_id, player_id)

* matchresults: match_id UNIQUE

---
## 5. Validate Real Relationships with Join(Players->PlayerStats)

```
SELECT
  p.first_name,
  p.last_name,
  p.position_id,
  ps.goals_scored,
  ps.red_cards,
  ps.yellow_cards
FROM players p
JOIN playerstats ps
  ON ps.player_id = p.player_id;
```
### Why this is a great sanity check
Counts are good, but joins prove relational integrity:

* if this returns rows, your FK values line up with real parent rows

---
## 6) Validate MatchResults references an actual Match
```
SELECT mr.*
FROM matchresults mr
LEFT JOIN matches m ON m.match_id = mr.match_id
WHERE m.match_id IS NULL;
```
### What this does

This checks: *"every match result points to a real match."*

And finds broken references

* If this returns zero rows, you’re good.

* If it returns rows, you have orphaned results (bad data).

## What This File Proves (High-Level)

After running sanity_check.sql, you should know:

✅ You’re connected to the correct DB \

✅ Seed ran and tables have data \

✅ Foreign keys exist (relationships are real) \

✅ Unique constraints exist (rules are enforced) \

✅ Joins work (data integrity holds) \

✅ Results don’t orphan (no broken references)