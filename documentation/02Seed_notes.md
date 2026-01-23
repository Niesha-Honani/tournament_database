# Seeding Data Walkthrough - 02data_seed.sql

Seed Data Logic \
Seed data should do 3 things:

* Prove the schema works

* Foreign keys should accept valid rows and reject invalid ones.

* Create realistic scenarios

    * multiple tournaments
    * teams in different tournaments
    * rosters + matches + stats

* Support debugging
    * when something breaks, you have predictable IDs and examples

---
Transaction Wrapper: BEGIN; ... COMMIT;
```
BEGIN;
...
COMMIT;
```
* If anything fails halfway, nothing gets permanently written.

* That means you don’t end up with half-seeded, corrupted test data.

NOTE: mock data is King for testing your code in the real world - it is the GOLD STANDARD for test scripts - "It's not the Data"

---
## Seed Order Matters -> Foreign Keys
Rule of Thumb:
Insert parent tables first. Insert child/junction tables after

In this seed file
1. Lookup tables
2. Parent tables
3. Junction/registration tables (tourney_teams, teamroster)
4. Rounds
5. Matches
6. Results
7. Stats

This order prevents FK errors:
* "insert violates foreign key constraints" - referenced row doesn't exist yet
---
### 1) Lookup Tables Seed
* locations: London, New York, Barcelona

* types: Single Elim, Round Robin

* coaches, countries, positions, nationalities

Why this is good

* Lookup tables are small but powerful: they enforce consistent labels.

* This makes it easy to join/filter later.

Upgrade idea: add UNIQUE constraints in schema so you can’t accidentally seed duplicates (e.g., insert “USA” twice).

---
### 2) Parent Tables: tournament, teams, players
tournament
```
INSERT INTO tournament (name, start_date, end_date, location_id, type_id) VALUES ...
```
Works for controlled seed script and mock data testing or queries

However if you add any new data - rebuild

---

**teams**

Seeded 6 teams and map them to:

* coach_id

* country_id

This creates realistic international variety.

---
**players**

Seeded 12 players with:

* positions

* DOBs

* nationalities

This matters because it lets you run “stats / roster / match” queries like a real app.

#### Tournament Team Registration: tourney_teams
Crucial table because of the composite FK in matches.
```
INSERT INTO tourney_teams (tourney_id, team_id) VALUES ...
```
Why it must happen before matches

Because matches enforces:

* team1 and team2 must be registered for that tournament

So if you try to insert a match with an unregistered team, Postgres will block it.

---
### 4) Team Roster: teamroster
```
INSERT INTO teamroster (team_id, tourney_id, player_id) VALUES ...
```
**Rule schema enforces**

UNIQUE(tourney_id, player_id) means:

*A player cannot appear on multiple teams in the same tournament.*

Seed data proves this rule works by:

* assigning all 12 players once each in tournament 1

* distributing 3 per team

Try inserting the same player twice for tourney 1 on a different team. It should fail.

---
### 5) Rounds
```
INSERT INTO rounds (round_number, tournament_id) VALUES ...
```
* tournament 1: rounds 1 and 2
* tournament 2: rounds 1 and 2

UNIQUE(tournament_id, round_number)\

**no duplicate round numbers inside a tournament**

---
### 6) Matches - Boss level Schema Rules Live Here
```
INSERT INTO matches (...)
VALUES (tournament_id, round_id, round_number, team1_id, team2_id, ...)
```
Seed data:
* tournament 1 has 3 matches (2 complete + 1 ongoing)
* tournament 2 has 1 ongoing match

Composite Foreign Keys (FK)
```
FOREIGN KEY (tournament_id, team1_id) REFERENCES tourney_teams(tourney_id, team_id),
FOREIGN KEY (tournament_id, team2_id) REFERENCES tourney_teams(tourney_id, team_id)
```

These inserts will fail if a team isn’t registered for that tournament.

✅ Seed data uses valid team IDs registered via tourney_teams.

---
### 7) Match Results (Only Completed Matches)

```
INSERT INTO matchresults (match_id, winningteam_id, matchdate, final_score) VALUES ...
```
* Only results for matches completed can be created

* Draw matches are recorded using winningteam_id = NULL

Consider: final_score

* 31 to represent “3–1”

* 22 to represent “2–2”

That’s fine for a toy schema, but in real systems this field is usually:

* text like '3-1', OR

* separate columns team1_final, team2_final, OR

* derived from match record

---
### 8) Player Stats (Per Tournament)

```
INSERT INTO playerstats (player_id, tournament_id, goals_scored, yellow_cards, red_cards) VALUES ...
```
UNIQUE(player_id, tournament_id)

---
### 9_ Player Match Stats (Per Player Match)

```
INSERT INTO playermatchstats (match_id, player_id, goals, yellow, red) VALUES ...
```
This table uses composite primary key:\

PRIMARY KEY (match_id, player_id)

Enforces:
* one player gets one stats row per match (no duplicates)

Seed match stats for :
* Match 1 (Thunderbolts vs Fire Dragons)

* Match 2 (Ice Wolves vs Storm Riders)

---
## CHEAT SHEET
Use this dependency chain when you build seed scripts:

* Lookup tables (no dependencies)

* Parent tables (depend on lookups)

* Registration / junction tables

    * tourney_teams depends on tournament + teams

    * teamroster depends on tournament + teams + players

* Rounds depend on tournament

* Matches depend on tournament + rounds + tourney_teams

* Results depend on matches

* Stats depend on players + tournament (+ matches for match stats)
