FROM postgres:16

COPY --chown=postgres 01tourney_schema.sql /docker-entrypoint-initdb.d/01tourney_schema.sql
COPY --chown=postgres 02data_seed.sql /docker-entrypoint-initdb.d/02data_seed.sql
