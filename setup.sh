#!/bin/bash
set -e

IMAGE=tournament_db_image
CONTAINER=tournament_container
DB=tournament_db
PORT=5432

# Clean reset
docker rm -f $CONTAINER 2>/dev/null || true

# Build fresh
docker build --no-cache -t $IMAGE .

# Run (NO --rm while debugging so we can see logs even if it exits)
docker run -d --name $CONTAINER \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=$DB \
  -p $PORT:5432 \
  $IMAGE

sleep 5

# If it died, show logs and exit
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
  echo "Container is not running. Showing logs:"
  docker logs $CONTAINER || true
  exit 1
fi

# Connect (inside container, host is localhost:5432)
docker exec -it $CONTAINER psql -U postgres -d $DB
