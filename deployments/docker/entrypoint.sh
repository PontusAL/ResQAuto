#!/usr/bin/env bash
set -euo pipefail

# Require a cron expression like: "*/1 * * * *" or "50 14 * * 1"
: "${CRON_EXPR:?Set CRON_EXPR (e.g., '*/1 * * * *' for each minute, or '50 14 * * 1' for Mon 14:50)}"

# Work from repo root inside the container
cd /app

# Cron often ignores container PATH; set it explicitly for the job
CRON_PATH="/opt/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
: "${TZ:=Etc/UTC}"

# Build a root crontab with environment lines so the venv Python is used
# and the app package can be found via PYTHONPATH. Route output to container logs.
CRON_CONTENT=$(cat <<EOF
SHELL=/bin/bash
PATH=${CRON_PATH}
TZ=${TZ}
${CRON_EXPR} /usr/bin/env bash -lc 'export PYTHONPATH=/app; exec /opt/venv/bin/python -m apps.queue_automation.main' >>/proc/1/fd/1 2>>/proc/1/fd/2
EOF
)

echo "$CRON_CONTENT" | crontab -

echo "[entrypoint] Installed crontab:" && crontab -l

# Run cron in the foreground so the container stays up
exec cron -f