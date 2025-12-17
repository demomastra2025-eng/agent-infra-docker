#!/bin/bash

############################################################################
# Container Entrypoint script
############################################################################

if [[ "$PRINT_ENV_ON_LOAD" = true || "$PRINT_ENV_ON_LOAD" = True ]]; then
  echo "=================================================="
  printenv
  echo "=================================================="
fi

if [[ "$WAIT_FOR_DB" = true || "$WAIT_FOR_DB" = True ]]; then
  dockerize \
    -wait tcp://$DB_HOST:$DB_PORT \
    -timeout 300s
fi

############################################################################
# Start App
############################################################################

case "$1" in
  chill)
    APP_PORT="${PORT:-8080}"
    echo "Running: uvicorn app.main:app --host 0.0.0.0 --port ${APP_PORT}"
    exec uvicorn app.main:app --host 0.0.0.0 --port "${APP_PORT}"
    ;;
  *)
    echo "Running: $@"
    exec "$@"
    ;;
esac
