-- Validate Tables
SELECT current_database();
SELECT current_schema();

-- Validate ALL seed data was loaded 
SELECT 'tournament' AS table, COUNT(*) FROM tournament
UNION ALL SELECT 'teams', COUNT(*) FROM teams
UNION ALL SELECT 'players', COUNT(*) FROM players -- 20 players
UNION ALL SELECT 'rounds', COUNT(*) FROM rounds
UNION ALL SELECT 'matches', COUNT(*) FROM matches
UNION ALL SELECT 'match_results', COUNT(*) FROM match_results
UNION ALL SELECT 'tourney_team', COUNT(*) FROM tourney_team
UNION ALL SELECT 'playerstats', COUNT(*) FROM playerstats; -- PlayerStats =20;

-- What relationships exist?
-- Foreign Keys indicates relationship (information schema metadata)
-- Tables about tables (table_constraints, key_column_usage, constraint+column_usage)
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

-- Parent -> child


-- Validate Player And Player Stats relationship
-- Player --> Player Stats
SELECT
  p.first_name,
  p.last_name,
  p.position,
  ps.goals_scored,
  ps.red_card,
  ps.yellow_card
FROM Players p
JOIN Playerstats ps
  ON ps.player_id = p.Player_ID;

