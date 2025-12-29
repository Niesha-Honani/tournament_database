FROM postgres:16

COPY --chown=nieshah 01tourney_schema.sql /docker-entrypoint-initdb.d/01tourney_schema.sql
COPY --chown=nieshah 02data_seed.sql /docker-entrypoint-initdb.d/02data_seed.sql
