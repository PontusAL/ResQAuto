#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Make sure Python can import the 'apps' package
export PYTHONPATH="$REPO_ROOT"

# Prefer Homebrew Python if present (often /opt/homebrew/bin/python3 on Apple Silicon)
PY="$(command -v python3 || true)"
if [[ -x "/opt/homebrew/bin/python3" ]]; then
  PY="/opt/homebrew/bin/python3"
fi
: "${PY:=/usr/bin/python3}"

exec "$PY" -m apps.queue_automation.main