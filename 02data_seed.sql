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
-- -- (truncated for brevity – full list continues up to 4 with varied names/positions/dobs/nationalities)
-- -- TournamentTeam (team registrations per tournament)
INSERT INTO Tourney_Team (tournament_id, team_id) VALUES (1, 1);
INSERT INTO Tourney_Team (tournament_id, team_id) VALUES (1, 2);
-- -- ... up to (18, 3, 4)
-- -- Playerstat (tournament-level player stats: goals, yellow/red cards)
INSERT INTO Playerstats (player_id, goals_scored, red_card, yellow_card) VALUES (1, 13, 8, 1);
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
