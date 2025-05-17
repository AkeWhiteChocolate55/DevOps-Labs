#!/bin/bash

echo "Waiting for PostgreSQL to become available..."
until PGPASSWORD=$DB_PASSWORD psql -h db -U "$DB_USER" -d "$DB_NAME" -c '\q' >/dev/null 2>&1; do
  sleep 2
done

if [ "$RUN_MIGRATIONS" = "true" ] && [ -d "/app/migrations" ]; then
  echo "Running migrations..."
  for file in /app/migrations/*.sql; do
    [ -f "$file" ] || continue
    echo "Applying: $(basename "$file")"
    PGPASSWORD=$DB_PASSWORD psql -h db -U "$DB_USER" -d "$DB_NAME" -f "$file"
  done
fi

exec java -jar /app/laba2-1.0-SNAPSHOT.jar