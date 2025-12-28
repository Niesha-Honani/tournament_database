-- Tournament
INSERT INTO Tournament (name, start_date, end_date, location, type) VALUES ('World Champions Cup 2025', '2025-06-01', '2025-06-15', 'London, UK', 'Single Elimination');
INSERT INTO Tournament (name, start_date, end_date, location, type) VALUES ('International League 2025', '2025-03-01', '2025-03-20', 'New York, USA', 'Round Robin');
INSERT INTO Tournament (name, start_date, end_date, location, type) VALUES ('Summer Invitational 2025', '2025-07-10', '2025-07-18', 'Barcelona, Spain', 'Single Elimination');
-- -- -- Teams
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Thunderbolts', 'Mike Johnson', 'USA');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Fire Dragons', 'Elena Rodriguez', 'Spain');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Ice Wolves', 'Lars Hansen', 'Norway');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Storm Riders', 'Aisha Khan', 'Pakistan');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Golden Eagles', 'Carlos Silva', 'Brazil');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Shadow Panthers', 'Kim Soo-jin', 'South Korea');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Lightning Hawks', 'David Brown', 'UK');
INSERT INTO Teams (team_name, coach_name, country) VALUES ('Phoenix Rising', 'Maria Lopez', 'Mexico');
-- -- Players
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Chris', 'Lee', 'Forward', '1996-03-03', 'Pakistan');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Casey', 'Garcia', 'Forward', '1991-12-14', 'Germany');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Jamie', 'Smith', 'Forward', '1992-02-07', 'Pakistan');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Casey', 'Taylor', 'Forward', '1994-06-17', 'Italy');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Chris', 'Jackson', 'Goalkeeper', '1994-12-11', 'Mexico');

INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Alex', 'Morales', 'Defender', '1995-08-22', 'Spain');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Jordan', 'Kim', 'Midfielder', '1998-04-15', 'South Korea');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Liam', 'O''Connor', 'Defender', '1993-11-03', 'Ireland');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Mateo', 'Rossi', 'Forward', '1997-06-19', 'Italy');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Ethan', 'Walker', 'Midfielder', '1996-09-28', 'USA');

INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Hiro', 'Tanaka', 'Defender', '1994-02-10', 'Japan');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Carlos', 'Mendez', 'Forward', '1992-07-07', 'Mexico');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Noah', 'Peterson', 'Goalkeeper', '1999-01-30', 'USA');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Samuel', 'Adeyemi', 'Midfielder', '1995-05-14', 'Nigeria');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Lucas', 'Bernard', 'Defender', '1996-12-02', 'France');

INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Ivan', 'Kovacic', 'Midfielder', '1994-03-18', 'Croatia');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Pedro', 'Alvarez', 'Forward', '1998-10-25', 'Argentina');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Daniel', 'Svensson', 'Defender', '1993-06-08', 'Sweden');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Omar', 'Hassan', 'Midfielder', '1997-09-12', 'Egypt');
INSERT INTO Players (first_name, last_name, position, dob, nationality) VALUES ('Andre', 'Silva', 'Forward', '1995-01-05', 'Brazil');

-- -- (truncated for brevity – full list continues up to 4 with varied names/positions/dobs/nationalities)
-- -- TournamentTeam (team registrations per tournament)
INSERT INTO Tourney_Team (tournament_id, team_id) VALUES (1, 1);
INSERT INTO Tourney_Team (tournament_id, team_id) VALUES (1, 2);
-- -- ... up to (18, 3, 4)
-- -- Playerstat (tournament-level player stats: goals, yellow/red cards)
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (1, 13, 8, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (2, 7, 0, 2);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (3, 4, 1, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (4, 10, 0, 3);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (5, 1, 0, 0);

INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (6, 6, 0, 2);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (7, 9, 1, 4);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (8, 2, 0, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (9, 12, 0, 3);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (10, 5, 0, 2);

INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (11, 8, 1, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (12, 3, 0, 0);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (13, 11, 0, 4);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (14, 0, 0, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (15, 6, 0, 2);

INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (16, 4, 1, 3);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (17, 9, 0, 2);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (18, 5, 3, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (19, 7, 2, 1);
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (20, 3, 1, 1);

-- -- ... 54 rows total, 3 players per registered team with realistic stats
-- -- Rounds
INSERT INTO Rounds (tournament_id, round_number) VALUES (1, 1);
INSERT INTO Rounds (tournament_id, round_number) VALUES (1, 2);
-- -- ... 8 rounds total
-- -- Matches
INSERT INTO Matches (tournament_id, round_number, team1_id, team2_id, match_date, team1_score, team2_score) VALUES (1, 1, 1, 2, '2025-06-08 14:00', 3, 1);
INSERT INTO Matches (tournament_id, round_number, team1_id, team2_id, match_date, team1_score, team2_score) VALUES (1, 1, 3, 4, '2025-06-08 17:00', 2, 2);
-- -- ... 15 matches, some with NULL scores for upcoming games
-- -- Match_results (only for completed matches)
INSERT INTO Match_results (match_date, final_score) VALUES ('2025-06-08 14:00', '3-1');
INSERT INTO Match_results (match_date, final_score) VALUES ('2025-07-10 14:00' , '3-1');
