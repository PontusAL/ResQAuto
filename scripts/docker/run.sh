#!/usr/bin/env bash
set -euo pipefail
# Hint if env file is missing
if [ ! -f deployments/docker/env/.env ]; then
  echo "Note: copy deployments/docker/env/.env.example -> deployments/docker/env/.env"
fi
docker compose -f deployments/docker/docker-compose.yml run --rm qa