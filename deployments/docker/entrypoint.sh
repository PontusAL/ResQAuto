#!/usr/bin/env bash
set -euo pipefail

# Require a cron expression like: "*/1 * * * *" or "50 14 * * 1"
: "${CRON_EXPR:?Set CRON_EXPR (e.g., '*/1 * * * *' for each minute, or '50 14 * * 1' for Mon 14:50)}"

# Make sure /app is the working dir
cd /app

# Build a root crontab that runs the app on schedule and sends output to container STDOUT/ERR
# /proc/1/fd/1 and /proc/1/fd/2 are the entrypoint's stdout/stderr (so `docker logs` works)
CRON_LINE="${CRON_EXPR} /usr/bin/env bash -lc 'export PYTHONPATH=/app; python3 -m apps.queue_automation.main' >>/proc/1/fd/1 2>>/proc/1/fd/2"
printf '%s\n' "$CRON_LINE" | crontab -

echo "[entrypoint] Installed crontab:"
crontab -l

# Run cron in the foreground so the container stays up
# Ubuntu's cron binary is 'cron' (Debian/Ubuntu) and supports -f for foreground
exec cron -f