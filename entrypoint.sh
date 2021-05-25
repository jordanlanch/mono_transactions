# File: docker_phx/entrypoint.sh
#!/bin/bash
# docker entrypoint script.

# assign a default for the database_user
DB_USER=${DATABASE_USER:-postgresui}

# wait until Postgres is ready
while ! pg_isready -q -h db -p 5432 -U $DB_USER; do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/transactions_mono"
eval "$bin eval \"TransactionsMono.Release.migrate\""

# start the elixir application
exec "$bin" "start"
