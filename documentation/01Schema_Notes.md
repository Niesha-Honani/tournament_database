# Overview of Tournament Database
## Schema Walkthrough - 01tourney_schema.sql
Database Models a tournament system:
- tournaments have teams 
- teams require rosters of players
- matches have rounds
- Tracked : results + player stats
- Business rules
---
### Model 
1. Create **Tournament** (location + type)
2. Register **Teams** into that tournament
3. Assign **Players** to teams **for that tournament (roster)**
4. Create **Rounds** (Round 1, Round 2, etc)
5. Create **Matches** in each round with **two registered teams**
6. Record **Match Results**
7. Track **Player Stats** (per tournament + per match)

---
## 1) Lookup Tables (Reference / "Dictionary" Tables)
*not to be confused with python dictionarys - regular dictionarys*

Lookup tables are the databse version of drop down menus
In the tournament table - using lookup tables eliminates typos like (US, us, U.S.A),
especially when you want to later make queries based on Coaches, Players, States, Countries,etc

It keeps the main **Tournament** table clean 

### Lookup Tables in this Schema
* location(location_ID, location)
* type(type_ID, type)
* coach(coach_ID, coach_name)
* country(country_ID, country)
* position(position_ID, position)
* nationality(nationality_ID, nationality)

### Rule Pattern: SERIAL PRIMARY KEY + TEXT NOT NULL + UNIQUE
Keeping lookup tables unique prevents having two versions of 
something like "forward" and "FORWARD" etc. and requires differentiating between 10 Smiths

---

## Parent Tables (Core)
| tournament

```
CREATE TABLE tournament (
  tournament_ID SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  location_ID INT NOT NULL REFERENCES location(location_ID),
  type_ID INT NOT NULL REFERENCES type(type_ID)
);
```
---
### Relationship Logic
* A tournament belongs to **one** location and **one** type (1:1)
* Location/type can be reused across many tournaments (1: Many)

**location_ID** and **type_ID** are **NOT NULL** -> tournament must have both

Consider: Rule to ensure end_date >= start_date with CHECK (how?)

---
| teams

```
CREATE TABLE teams (
  team_ID SERIAL PRIMARY KEY,
  team_name TEXT NOT NULL,
  coach_id INT REFERENCES coach(coach_ID),
  country_id INT REFERENCES country(country_ID)
);
```
Consider:

* Coach and country are optional (no NOT NULL), meaning you can create a team before assigning those details.
* Team names can be UNIQUE 
---
| players
```
CREATE TABLE players (
  player_ID SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  position_id INT REFERENCES position(position_ID),
  dob DATE,
  nationality_id INT REFERENCES nationality(nationality_ID)
);
```
Players are independent of teams / tournaments
* Data independent of other datais called **Data Independence** (Database Fundamentals course must learn)
    - You can change the schema in like Teams or tournaments and it doesn't affect Players (logical data independence)
    
    - **Modality** specifies whether a relationship between two entities are optional or mandatory (data modeling)

    - There is a data modality but that's AI stuff
---
## Tournament Registration vs Team Rosters
A) Register teams in tournaments -> tourney_teams
```
CREATE TABLE tourney_teams (
  tourneyTeam_ID SERIAL PRIMARY KEY,
  tourney_id INT REFERENCES tournament(tournament_ID),
  team_id INT REFERENCES teams(team_ID),
  UNIQUE(tourney_id, team_id)
);
```
* A team can exist wihout being in every tournament 
* UNIQUE(tourney_id, team_id) = a team can only register once per tournament.

Consider:
* NOT NULL on these foreign keys so registration row can't be half-empty
---

### Assign Players to Teams for *specific tournament*: teamroster

```
CREATE TABLE teamroster (
  roster_ID SERIAL PRIMARY KEY,
  team_id INT NOT NULL REFERENCES teams(team_ID),
  tourney_id INT NOT NULL REFERENCES tournament(tournament_ID),
  player_id INT NOT NULL REFERENCES players(player_ID),
  UNIQUE(tourney_id, player_id)
);
```
Real World Rule Enforced
* UNIQUE(tourney_id, player_id) means:
    - A player can only be on **one team per tournament**
    - Why ?

Relationship Type
* This is a many-to-many relationship *with context*
    - Player <-> Team is many-to-many **across time**
    - But within a single tournament, it becomes "one team max"

Business Rule to Consider:\
Team must be registered in that tournament before adding roster players. Look at **matches** using composite FK 

---
### Rounds and Matches
rounds
```
CREATE TABLE rounds (
  round_ID SERIAL PRIMARY KEY,
  round_number INT NOT NULL,
  tournament_id INT NOT NULL REFERENCES tournament(tournament_ID),
  UNIQUE(tournament_id, round_number)
);
```
UNIQUE(tournament_id, round_number) prevents duplicate "Round 1" for the same tournament

---
matches
```
CREATE TABLE matches (
  match_ID SERIAL PRIMARY KEY,
  tournament_id INT REFERENCES tournament(tournament_ID),
  round_id INT REFERENCES rounds(round_ID),
  round_number INT,
  team1_id INT NOT NULL,
  team2_id INT NOT NULL,
  match_date TIMESTAMP,
  team1_score INT,
  team2_score INT,
  is_complete BOOL DEFAULT FALSE,

  FOREIGN KEY (tournament_id, team1_id) REFERENCES tourney_teams(tourney_id, team_id),
  FOREIGN KEY (tournament_id, team2_id) REFERENCES tourney_teams(tourney_id, team_id)
);
```
Composite Foreign Keys Matter
* Enforces this rule: \
"You can't schedule a match using teams that aren't registered in that tournament."

So the database blocks invalid match inserts automatically.

Inconsistency in this database
* Either store round_id only (recommended)

* Or store round_number only and drop rounds table (less flexible)

Consider:
* Prevent team playing itself : CHECK(team1_id <> team2_id)
* Prevent negative scores CHECK (team_score >=0 AND team2_score >=0)

---
### Match Results (One to One with matches)
```
CREATE TABLE matchResults (
  results_ID SERIAL PRIMARY KEY,
  match_id INT UNIQUE REFERENCES matches(match_ID),
  winningTeam_ID INT REFERENCES teams(team_ID),
  matchDate TIMESTAMP,
  final_score INT
);
```
match_id INT UNIQUE makes it 1:1:

Each match can have at most one results record.

Consider:
team1_final, team2_final or compute matches instead of final_score INT

---
### Player Stats (Tournament-wide + Match specific)
playerStats (Tournament-wide)
```
CREATE TABLE playerStats (
  stats_ID SERIAL PRIMARY KEY,
  player_id INT NOT NULL REFERENCES players(player_ID),
  tournament_id INT NOT NULL REFERENCES tournament(tournament_ID),
  goals_scored INT DEFAULT 0,
  yellow_cards INT DEFAULT 0,
  red_cards INT DEFAULT 0,
  UNIQUE(player_id, tournament_id)
);
```
UNIQUE(player_id, tournament_id) ensures:
* One stats row per player per tournament
* This prevents duplicates and makes updates predictable

---
playerMatchStats (match-specific)
```
CREATE TABLE playerMatchStats (
  match_id INT REFERENCES matches(match_ID),
  player_id INT REFERENCES players(player_ID),
  goals INT,
  yellow INT,
  red INT,
  PRIMARY KEY (match_id, player_id)
);
```
Composite primary key means:
* A player gets one stats row per match.
* Junction table with attributes

---
## RELATIONSHIP SUMMARY CHEAT SHEET

* Tournament → Rounds: 1-to-many
* Tournament ↔ Teams: many-to-many via tourney_teams
* Teams ↔ Players: many-to-many via teamroster (scoped to tournament)
* Rounds → Matches: 1-to-many
* Matches → MatchResults: 1-to-1
* Players ↔ Matches: many-to-many via playerMatchStats

