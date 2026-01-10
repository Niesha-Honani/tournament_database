-- Lookup Tables

CREATE TABLE location (
  location_ID SERIAL PRIMARY KEY,
  location TEXT NOT NULL
);

CREATE TABLE type (
  type_ID SERIAL PRIMARY KEY,
  type TEXT NOT NULL
);

CREATE TABLE coach (
  coach_ID SERIAL PRIMARY KEY,
  coach_name TEXT NOT NULL
);

CREATE TABLE country (
  country_ID SERIAL PRIMARY KEY,
  country TEXT NOT NULL
);

CREATE TABLE position (
  position_ID SERIAL PRIMARY KEY,
  position TEXT NOT NULL
);

CREATE TABLE nationality (
  nationality_ID SERIAL PRIMARY KEY,
  nationality TEXT NOT NULL
);

-- PARENT TABLES

CREATE TABLE tournament (
  tournament_ID SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  location_ID INT NOT NULL REFERENCES location(location_ID),
  type_ID INT NOT NULL REFERENCES type(type_ID)
);

CREATE TABLE teams (
  team_ID SERIAL PRIMARY KEY,
  team_name TEXT NOT NULL,
  coach_id INT REFERENCES coach(coach_ID),
  country_id INT REFERENCES country(country_ID)
);

CREATE TABLE players (
  player_ID SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  position_id INT REFERENCES position(position_ID),
  dob DATE,
  nationality_id INT REFERENCES nationality(nationality_ID)
);


-- Players assigned to a team in a tournament
-- Players can only be on one team per tournament

CREATE TABLE teamroster (
  roster_ID SERIAL PRIMARY KEY,
  team_id INT NOT NULL REFERENCES teams(team_ID),
  tourney_id INT NOT NULL REFERENCES tournament(tournament_ID),
  player_id INT NOT NULL REFERENCES players(player_ID),
  UNIQUE(tourney_id, player_id)
);

-- Tournament Team Registration

CREATE TABLE tourney_teams (
  tourneyTeam_ID SERIAL PRIMARY KEY,
  tourney_id INT REFERENCES tournament(tournament_ID),
  team_id INT REFERENCES teams(team_ID),
  UNIQUE(tourney_id, team_id)
);


-- Rounds and Matches

CREATE TABLE rounds (
  round_ID SERIAL PRIMARY KEY,
  round_number INT NOT NULL,
  tournament_id INT NOT NULL REFERENCES tournament(tournament_ID),
  UNIQUE(tournament_id, round_number)
);

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

  -- Team 1 and Team 2 Registered in Tournament
  FOREIGN KEY (tournament_id, team1_id) REFERENCES tourney_teams(tourney_id, team_id),
  FOREIGN KEY (tournament_id, team2_id) REFERENCES tourney_teams(tourney_id, team_id)
);

-- Match Results (1:1 with match)
CREATE TABLE matchResults (
  results_ID SERIAL PRIMARY KEY,
  match_id INT UNIQUE REFERENCES matches(match_ID),
  winningTeam_ID INT REFERENCES teams(team_ID),
  matchDate TIMESTAMP,
  final_score INT
);

-- Player Stats
CREATE TABLE playerStats (
  stats_ID SERIAL PRIMARY KEY,
  player_id INT NOT NULL REFERENCES players(player_ID),
  tournament_id INT NOT NULL REFERENCES tournament(tournament_ID),
  goals_scored INT DEFAULT 0,
  yellow_cards INT DEFAULT 0,
  red_cards INT DEFAULT 0,
  UNIQUE(player_id, tournament_id)
);

CREATE TABLE playerMatchStats (
  match_id INT REFERENCES matches(match_ID),
  player_id INT REFERENCES players(player_ID),
  goals INT,
  yellow INT,
  red INT,
  PRIMARY KEY (match_id, player_id)
);





