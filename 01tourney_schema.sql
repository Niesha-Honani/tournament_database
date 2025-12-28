CREATE TABLE Tournament(
Tournament_ID SERIAL PRIMARY KEY,
name TEXT,
start_date DATE,
end_date  DATE,
location TEXT,
type TEXT
);

CREATE TABLE Matches(
Match_ID SERIAL PRIMARY KEY,
tournament_id INT REFERENCES Tournament(Tournament_ID),
round_number INT,
team1_id INT,
team2_id INT,
match_date TIMESTAMP,
team1_score INT,
team2_score INT);

CREATE TABLE ROUNDS(
Rounds_ID SERIAL PRIMARY KEY,
tournament_id INT,
round_number INT
);

CREATE TABLE Match_results(
MatchResult_ID SERIAL PRIMARY KEY,
winning_team_id INT,
match_date DATE,
final_score TEXT
);

CREATE TABLE Teams(
team_ID SERIAL PRIMARY KEY,
team_name TEXT,
coach_name TEXT,
country TEXT
);

CREATE TABLE Players(
Player_ID SERIAL PRIMARY KEY,
first_name TEXT,
last_name TEXT,
position VARCHAR(50),
dob  VARCHAR(50),
nationality TEXT
);

CREATE TABLE Playerstats(
PlayerStats_ID SERIAL PRIMARY KEY,
player_id INT REFERENCES Players(Player_ID),
matchResult_id INT REFERENCES Match_results(MatchResult_ID),
goals_scored INT,
red_card TEXT,
yellow_card TEXT
);


CREATE TABLE Tourney_Team(
TourneyTeam_ID SERIAL  PRIMARY KEY,
tournament_id INT REFERENCES Tournament(Tournament_ID),
team_id INT REFERENCES Teams(Team_ID),
player_id INT REFERENCES Players(Player_ID)
);

