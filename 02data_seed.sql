BEGIN;

-- =========================================================
-- 1) LOOKUP TABLES
-- =========================================================
INSERT INTO location (location) VALUES
  ('London, UK'),
  ('New York, USA'),
  ('Barcelona, Spain');

INSERT INTO type (type) VALUES
  ('Single Elimination'),
  ('Round Robin');

INSERT INTO coach (coach_name) VALUES
  ('Mike Johnson'),
  ('Elena Rodriguez'),
  ('Lars Hansen'),
  ('Aisha Khan');

INSERT INTO country (country) VALUES
  ('USA'),
  ('Spain'),
  ('Norway'),
  ('Pakistan'),
  ('Mexico'),
  ('Germany');

INSERT INTO position (position) VALUES
  ('Goalkeeper'),
  ('Defender'),
  ('Midfielder'),
  ('Forward');

INSERT INTO nationality (nationality) VALUES
  ('USA'),
  ('Spain'),
  ('Norway'),
  ('Pakistan'),
  ('Mexico'),
  ('Germany');

-- =========================================================
-- 2) PARENT TABLES: tournament, teams, players
-- =========================================================
-- Tournament IDs will become: 1, 2, 3
INSERT INTO tournament (name, start_date, end_date, location_id, type_id) VALUES
  ('World Champions Cup 2025', '2025-06-01 09:00', '2025-06-15 18:00', 1, 1),
  ('International League 2025', '2025-03-01 09:00', '2025-03-20 18:00', 2, 2),
  ('Summer Invitational 2025', '2025-07-10 09:00', '2025-07-18 18:00', 3, 1);

-- Team IDs will become: 1..6
INSERT INTO teams (team_name, coach_id, country_id) VALUES
  ('Thunderbolts',     1, 1),
  ('Fire Dragons',     2, 2),
  ('Ice Wolves',       3, 3),
  ('Storm Riders',     4, 4),
  ('Golden Eagles',    2, 1),
  ('Shadow Panthers',  3, 2);

-- Player IDs will become: 1..12
INSERT INTO players (first_name, last_name, position_id, dob, nationality_id) VALUES
  ('Chris',  'Jackson', 1, '1994-12-11', 5), -- GK, Mexico
  ('Casey',  'Garcia',  4, '1991-12-14', 6), -- F, Germany
  ('Jamie',  'Smith',   4, '1992-02-07', 4), -- F, Pakistan
  ('Taylor', 'Nguyen',  3, '1997-05-22', 1), -- M, USA
  ('Morgan', 'Diaz',    2, '1995-08-30', 2), -- D, Spain
  ('Avery',  'Hansen',  2, '1993-03-19', 3), -- D, Norway
  ('Riley',  'Khan',    3, '1998-11-02', 4), -- M, Pakistan
  ('Jordan', 'Lee',     4, '1996-03-03', 1), -- F, USA
  ('Sam',    'Lopez',   3, '1999-01-09', 5), -- M, Mexico
  ('Peyton', 'Brown',   2, '1990-10-04', 1), -- D, USA
  ('Drew',   'Kim',     4, '1997-06-18', 2), -- F, Spain
  ('Quinn',  'Singh',   3, '1996-04-15', 4); -- M, Pakistan

-- =========================================================
-- 3) TOURNAMENT TEAM REGISTRATION (tourney_teams)
-- Needed BEFORE matches due to composite FK on matches.
-- =========================================================
-- World Champions Cup 2025 (tourney_id=1): teams 1,2,3,4
INSERT INTO tourney_teams (tourney_id, team_id) VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4);

-- International League 2025 (tourney_id=2): teams 1,2,5,6
INSERT INTO tourney_teams (tourney_id, team_id) VALUES
  (2, 1),
  (2, 2),
  (2, 5),
  (2, 6);

-- Summer Invitational 2025 (tourney_id=3): teams 3,4,5,6
INSERT INTO tourney_teams (tourney_id, team_id) VALUES
  (3, 3),
  (3, 4),
  (3, 5),
  (3, 6);

-- =========================================================
-- 4) TEAM ROSTER (teamroster)
-- Enforces: UNIQUE(tourney_id, player_id)
-- =========================================================
-- Tournament 1 rosters (4 teams × 3 players = 12 assignments)
-- Team 1 Thunderbolts: players 1,4,8
INSERT INTO teamroster (team_id, tourney_id, player_id) VALUES
  (1, 1, 1),
  (1, 1, 4),
  (1, 1, 8);

-- Team 2 Fire Dragons: players 2,3,5
INSERT INTO teamroster (team_id, tourney_id, player_id) VALUES
  (2, 1, 2),
  (2, 1, 3),
  (2, 1, 5);

-- Team 3 Ice Wolves: players 6,9,10
INSERT INTO teamroster (team_id, tourney_id, player_id) VALUES
  (3, 1, 6),
  (3, 1, 9),
  (3, 1, 10);

-- Team 4 Storm Riders: players 7,11,12
INSERT INTO teamroster (team_id, tourney_id, player_id) VALUES
  (4, 1, 7),
  (4, 1, 11),
  (4, 1, 12);


-- =========================================================
-- 5) ROUNDS
-- =========================================================
-- Tournament 1 has rounds 1 and 2
INSERT INTO rounds (round_number, tournament_id) VALUES
  (1, 1),
  (2, 1);

-- Tournament 2 has rounds 1 and 2
INSERT INTO rounds (round_number, tournament_id) VALUES
  (1, 2),
  (2, 2);

-- =========================================================
-- 6) MATCHES
-- Must use teams that exist in tourney_teams for that tournament.
-- =========================================================
-- Helper: Round IDs (based on insert order)
-- rounds for tournament 1: round_id 1 (round 1), round_id 2 (round 2)
-- rounds for tournament 2: round_id 3 (round 1), round_id 4 (round 2)

-- Tournament 1 round 1: Thunderbolts vs Fire Dragons (complete)
INSERT INTO matches (tournament_id, round_id, round_number, team1_id, team2_id, match_date, team1_score, team2_score, is_complete)
VALUES
  (1, 1, 1, 1, 2, '2025-06-08 14:00', 3, 1, TRUE);

-- Tournament 1 round 1: Ice Wolves vs Storm Riders (complete draw)
INSERT INTO matches (tournament_id, round_id, round_number, team1_id, team2_id, match_date, team1_score, team2_score, is_complete)
VALUES
  (1, 1, 1, 3, 4, '2025-06-08 17:00', 2, 2, TRUE);

-- Tournament 1 round 2: winners match (scheduled/ongoing)
INSERT INTO matches (tournament_id, round_id, round_number, team1_id, team2_id, match_date, team1_score, team2_score, is_complete)
VALUES
  (1, 2, 2, 1, 3, '2025-06-12 18:00', NULL, NULL, FALSE);

-- Tournament 2 round 1: Thunderbolts vs Golden Eagles (ongoing)
INSERT INTO matches (tournament_id, round_id, round_number, team1_id, team2_id, match_date, team1_score, team2_score, is_complete)
VALUES
  (2, 3, 1, 1, 5, '2025-03-05 18:30', NULL, NULL, FALSE);

-- =========================================================
-- 7) MATCH RESULTS (only completed matches)
-- matchresults.match_id is UNIQUE and references matches(match_id)
-- =========================================================
-- Note: match_id values will be 1..4 based on insertion order above
INSERT INTO matchresults (match_id, winningteam_id, matchdate, final_score) VALUES
  (1, 1, '2025-06-08 14:00', 31), -- Thunderbolts win 3-1
  (2, NULL, '2025-06-08 17:00', 22); -- draw represented by NULL winner, final_score=22

-- =========================================================
-- 8) PLAYER STATS (per tournament)
-- playerstats unique (player_id, tournament_id)
-- =========================================================
INSERT INTO playerstats (player_id, tournament_id, goals_scored, yellow_cards, red_cards) VALUES
  (8, 1, 2, 0, 0), -- Jordan Lee
  (2, 1, 1, 1, 0), -- Casey Garcia
  (3, 1, 0, 0, 0), -- Jamie Smith
  (4, 1, 0, 1, 1), -- Taylor Nguyen
  (11,1, 1, 0, 0), -- Drew Kim
  (7, 1, 0, 1, 0); -- Riley Khan

-- =========================================================
-- 9) PLAYER MATCH STATS (per match per player)
-- playermatchstats PK(match_id, player_id)
-- =========================================================
INSERT INTO playermatchstats (match_id, player_id, goals, yellow, red) VALUES
  -- Match 1: Thunderbolts vs Fire Dragons
  (1, 8, 2, 0, 0),
  (1, 4, 1, 1, 0),
  (1, 2, 1, 1, 0),

  -- Match 2: Ice Wolves vs Storm Riders
  (2, 11, 1, 0, 0),
  (2, 12, 1, 0, 0),
  (2, 6,  1, 0, 0),
  (2, 9,  1, 0, 0);

COMMIT;

