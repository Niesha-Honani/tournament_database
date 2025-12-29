# Tournament Database — Schema, Requirements, and Design Rationale
    ##1. Purpose of the Database

    The Tournament Database is designed to model competitive sports tournaments.
    It supports:

    - Multiple tournaments

    - Team registration per tournament

    - Player participation with the constraint that a player can only play for one team per tournament

    - Matches organized into rounds

    - Player statistics tracked per tournament and per match

    - Match results and completion state

    This schema enforces business rules at the database level using keys and constraints.

    ##2. High-Level Entity Overview
    ###Core Entities

    - Tournament — represents a competition event

    - Teams — represent participating teams

    - Players — individual athletes

    - Rounds — stages within a tournament

    - Matches — games played between teams

    - MatchResults — final outcomes of completed matches

    ###Supporting / Relationship Entities

    - tourney_teams — registers teams into tournaments

    - teamroster — assigns players to teams per tournament

    - playerstats — aggregate stats per player per tournament

    - playermatchstats — per-match player performance

    ###Lookup Tables

    - location

    - type

    - coach

    - country

    - position

    - nationality

    ##3. Key Business Rules & How They Are Enforced
    ### Business Rule	Enforcement Mechanism
    - Tournament has multiple rounds	rounds.tournament_id → tournament
    - Round has multiple matches	matches.round_id → rounds
    - Team must be registered to play in tournament	Composite FK (tournament_id, team_id)
    - Player can only be on one team per tournament	UNIQUE (tourney_id, player_id)
    - Player stats tracked per tournament	UNIQUE (player_id, tournament_id)
    - Player stats tracked per match	Composite PK (match_id, player_id)
    - One result per match	matchresults.match_id UNIQUE
    - Match can be ongoing or completed	matches.is_complete BOOLEAN
    ##4. Cardinality (Relationships)
    ### One-to-Many

    - Tournament → Rounds

    - Tournament → Matches

    - Round → Matches

    - Team → Players (via teamroster)

    - Match → PlayerMatchStats

    ### Many-to-Many (via bridge tables)

    - Tournament ↔ Teams (tourney_teams)

    - Tournament ↔ Players (teamroster)

    - Match ↔ Players (playermatchstats)

    ### One-to-One

    - Match ↔ MatchResults

    ##5. Normalization Strategy

    This schema is normalized to Third Normal Form (3NF):

    ### 1NF (Atomic Values)

    - No multi-valued columns

    - All fields store single values

    ### 2NF (No Partial Dependencies)

    - Composite keys (e.g., playermatchstats) contain no partial dependencies

    ### 3NF (No Transitive Dependencies)

    - Lookup tables remove repeated values:

        - country

        - nationality

        - position

        - coach

        - type

        - location

    ## 6. Indexing & Performance

    Indexes are used to:

    - Enforce uniqueness

    - Speed up joins

    - Protect business rules

    Examples:

        - UNIQUE (tourney_id, team_id)

        - UNIQUE (tourney_id, player_id)

        - UNIQUE (player_id, tournament_id)

    Composite primary keys on junction tables

    ## 7. Why This Design Is Assessment-Ready

    This schema demonstrates:

    - Correct use of primary and foreign keys

    - Proper normalization

    - Cardinality control

    - Business-rule enforcement via constraints

    - Separation of concerns

    - Real-world modeling (matches, rosters, stats)
