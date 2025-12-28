# Tournament Database Documentation

## Requirements
### Tables
 1. Tournaments
    - Attributes
        - Tournament ID (INT PK)
        - Name (TEXT)
        - Start Date (TIMESTAMP)
        - End Date (TIMESTAMP)
        - Location
        - Type (Single Elimination, Round Robin, etc)

    - Constraints
        - Each Tournament can have multiple rounds (Tournament -> Rounds)
        - Each Round can contain multiple matches (Round -> Matches)

 2. Teams
    - Attributes
        - Team ID (INT PK)
        - Team Name
        - Coach Name
        - Country

    - Constraints
        - Each team can have multiple players (Team -> Players)
        - Player can be on only one team per tournament (Player -> Team -> Tournament)
        - Players can play in multiple Tournaments (Player | Team -> Tournament)


 3. Players
    - Attributes
        - Player ID (INT PK)
        - First Name
        - Last Name
        - Position
        - Date of Birth
        - Nationality
    
    - Constraints
        - A player can only be part of one team in a tournament,
        they must be associated with a TEAM in EACH TOURNAMENT (Player --> Team --> Tournament)
        - Player Stats (Goals Scored, Yellow Card, Red Cards) PER TOURNAMENT


 4. Matches
    - Attributes
        - Match ID (INT PK)
        - Tournament ID
        - Round Number
        - Team1 ID
        - Team2 ID
        - Match Date
        - Team1 Score
        - Team2 Score

    - CONSTRAINTS
        - Track if a match is complete or still ongoing
        - Each Match - store individual player performance (Player stats by PlayerID)

 5. Match Results
    - Attributes
        - Match ID (INT PK)
        - Winning Team ID
        - Match Date
        - Final Score

    - Constraints
       - Each Match, Players should be associated with Specific results (Player -> Player Match Stats)

 6. Rounds
    - Attributes
        - Round ID
        - Tournament ID
        - Round Number
        - List of Matches

    - Constraints
        - Each tournament will have one or more Rounds (Rounds -> Tournament)
        - A round can contain multiple Matches (Round -> Matches)
        - List of Matches played in that round

