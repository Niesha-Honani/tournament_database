# Dockerized Build & Run (setup.sh + Dockerfile)

Goal: Make the database reproducible.

Anyone on should be able to run one command and get:

* Postgres running in Docker

* schema created

* seed data loaded

* ready to query

This is the “professional” part of the project: not just designing data, but making it easy to spin up consistently.

---
## How This Repo Boots the Database
Leverage built-in features of Postgres Docker images:
* Any **.sql** files placed into:
```
/docker-entrypoint-initdb.d/
```
...will automatically run **the first time** the container initializes a brand-new database directory.

That means:
* Schema loads
* Seed loads
* Then DB is ready

No manual **psql 0f schema.sql** needed during first initialization

---
# Dockerfile Walkthrough
```
FROM postgres:16

COPY --chown=postgres 01tourney_schema.sql /docker-entrypoint-initdb.d/01tourney_schema.sql
COPY --chown=postgres 02data_seed.sql /docker-entrypoint-initdb.d/02data_seed.sql
```

**What each line means**

```FROM postgres:16```

Uses the official Postgres base image version 16

* Includes postgres server + psql client

* Includes entrypoint logic that runs init scripts automatically

---
```
COPY --chown=postgres ... /docker-entrypoint-initdb.d/...
```

* Copies your SQL files into the “auto-run on first init” directory

* Sets the owner to postgres to avoid permission issues

### The execution order

Because filenames sort alphabetically:

1. 01tourney_schema.sql

2. 02data_seed.sql

That’s perfect because seed depends on tables existing.

**I learned this the hardway:**

If you see an error regarding table not existing might be this. Add 01 or 02 and it will load in order.

---

### 🚨 These SQL files run ONLY on first initialization

If you keep the same container volume / data directory, Postgres will **not** re-run init scripts

So....

*"It didn't update when I rebuilt"*

...it's usually because:
* the DB data directory already exists

* Postgres thinks it's already initialized

✅ Solution: remove the container + remove the volume / start fresh.

The initial setup has a clean reset by removing containers but for later remove volumes too.

# setup.sh Walkthrough
```
#!/bin/bash
set -e
```
**What this does**

* **set -e** makes the script exit immediately if any command fails
(this is good: it prevents silent broken setups)

---
### Configuration Variables
```
IMAGE=tournament_db_image
CONTAINER=tournament_container
DB=tournament_db
PORT=5432
```
Like switches in a cockpit:
* image name (what you build)

* container name (what runs)

* DB name (created by Postgres on init)

* host port mapping

Reminder: If 5432 is used already locally, switch the PORT to 5433 

---
### Clean Reset
```
docker rm -f $CONTAINER 2>/dev/null || true
```
This force-removes the container if it exists.

* **2>/dev/null** hides “container not found” errors

* **|| true** ensures the script continues even if removal fails

✅ This is a clean dev workflow: always start from a known state.

---
### Build Fresh
```
docker build --no-cache -t $IMAGE .
```
* **--no-cache** forces Docker to rebuild even if it thinks nothing changed

* Great for learning/debugging

* Slightly slower, but predictable
---
### Run Container
```
docker run -d --name $CONTAINER \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=$DB \
  -p $PORT:5432 \
  $IMAGE
```
**What this means**

* **POSTGRES_USER=postgres** creates the admin user postgres

* **POSTGRES_PASSWORD=postgres** sets its password

* **POSTGRES_DB=tournament_db** creates the database

* **-p 5432:5432** exposes Postgres to your host machine

✅ After this, you should be able to connect from your host at:

* host: localhost

* port: $PORT (usually 5432)

* db: tournament_db
---
### Startup Delay
```
sleep 5
```
**zzzzz**

---
### Crash Detection + Logs
```
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
  echo "Container is not running. Showing logs:"
  docker logs $CONTAINER || true
  exit 1
fi
```
If container exits early -> print logs -> exit with failure

---
### Connecting to the Database
```
docker exec -it $CONTAINER psql -U postgres -d $DB
```
---
# Run SOP
1) Run script
```
chmod +x setup.sh
./setup.sh
```

2) Verify tables exist (inside psql)
```
\dt
```

3) Spot-check seeded data

```
SELECT COUNT(*) FROM tournament;
SELECT COUNT(*) FROM teams;
SELECT COUNT(*) FROM matches;
```

# Common Problems
**Problem**: *“I rebuilt but schema didn’t change”*

**Cause**: Postgres init scripts only run on first init
**Fix**: Delete container + delete volume (if using volumes)

**Problem**: *“role does not exist”*

**Cause**: connecting with wrong user
**Fix**: connect with -U postgres or change POSTGRES_USER

**Problem**: *“port already in use”*

**Cause**: local Postgres running on 5432
**Fix**: set PORT=5433 and rerun
