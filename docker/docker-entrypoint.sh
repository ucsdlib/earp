#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Extract DB host and port
if [ "${APPS_H5_DB_HOST}" ]; then
  db_host="$APPS_H5_DB_HOST"
  db_port=5432
fi

if [ -z "${db_host}" ]; then
  echo "No database host information found; skipping database setup"
else
  # if port wasn't specified, use default PG port
  if [ "$db_port" = "$db_host" ]; then
    db_port=5432
  fi

  while ! nc -z "$db_host" "$db_port"
  do
    echo "waiting for postgresql"
    sleep 1
  done

  if [ -z "${DATABASE_COMMAND}" ]; then
    echo "DATABASE_COMMAND is not supplied, skipping database rake tasks"
  else
    # Support env var option for database command(s)
    for db_command in $DATABASE_COMMAND; do
      bundle exec rake "$db_command"
    done

    if [ ! "$RAILS_ENV" = "test" ]; then
      # populate LDAP employee data
      bundle exec rake nightly:employees
    fi
  fi
fi

# Then exec the container's main process
# This is what's set as CMD in a) Dockerfile b) compose c) CI
exec "$@"
