// DB Design Layout + Relations
Table Tournament {
  tournament_ID INT PK
  name text
  start_date timestamp
  end_date timestamp
  location INT [not null]
  type INT [not null]
}

Table location {
  location_ID INT PK
  location TEXT
}

Table type {
  type_ID INT PK
  type Text
}

Table tourney_teams {
  ttRoster_ID INT PK
  tourney_id int
  team_id int
  team_roster int

  Indexes {
    (tourney_id, team_id) [unique]
  }
}

Table teams {
  team_id INT PK
  team_name text
  coach_id int
  country int
}

Table coach {
  coach_ID INT PK
  coach text
}

Table country {
  country_ID INT PK
  country_name text
}

Table teamRoster {
  roster_id INT PK
  teams_id int
  tourney_id int
  player_id int

  Indexes {
    (tourney_id, player_id) [unique]
  }
}

// table belonged to a schema
Table Matches {
  matches_ID INT PK
  tournament_id INT [ref: > Tournament.tournament_ID]
  round_id INT [ref: > Rounds.round_ID]
  round_number INT
  team1_id int 
  team2_id int
  match_date timestamp
  team1_score int 
  team2_score int
  is_complete bool [default: false]
}

Table Rounds {
  round_ID INT PK
  round_number int
  tournament_id int

  indexes { (tournament_id, round_number) [unique]}
}

Table MatchResults {
  result_ID INT PK
  match_id INT UNIQUE [ref: > Matches.matches_ID]
  winningTeam_id INT
  matchDate timestamp
  finalScore int
}

Table Players{
  players_ID INT PK
  first_name text
  last_name text
  position INT
  dob date
  nationality int
}

Table position {
  position_ID INT PK
  position text
}

Table nationality{
  national_ID INT PK
  nationality TEXT
}

Table Playerstats{
  stats_ID INT PK
  player_id INT
  tournament_id INT
  goals_scored INT
  yellow_cards INT
  red_cards INT

  Indexes {
    (player_id, tournament_id) [unique]
  }
}

Table PlayerMatchStats{
  match_ID INT [ref: > Matches.matches_ID]
  player_ID INT [ref: > Players.players_ID]
  goals int
  yellow int
  red int

  Indexes { (match_ID, player_ID) [pk]}
}

Ref: "Tournament"."location" > "location"."location_ID"

Ref: "Tournament"."type" > "type"."type_ID"

Ref: "Playerstats"."player_id" > "Players"."players_ID"

Ref: "Players"."position" > "position"."position_ID"

Ref: "Players"."nationality" < "nationality"."national_ID"

Ref: "tourney_teams"."tourney_id" < "Tournament"."tournament_ID"

Ref: "teams"."team_id" < "tourney_teams"."team_id"

Ref: "teams"."coach_id" < "coach"."coach_ID"

Ref: "teams"."country" < "country"."country_ID"

Ref: "Rounds"."tournament_id" < "Tournament"."tournament_ID"

Ref: "tourney_teams"."team_roster" < "teamRoster"."roster_id"

Ref: "teamRoster"."teams_id" < "teams"."team_id"

Ref: "teamRoster"."tourney_id" < "Tournament"."tournament_ID"

Ref: "teamRoster"."player_id" < "Players"."players_ID"

Ref: "Playerstats"."tournament_id" < "Tournament"."tournament_ID"
