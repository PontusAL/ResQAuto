#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root regardless of where this script is called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "$REPO_ROOT"

# Default QA_NAME if not provided by environment
: "${QA_NAME:=MacUser}"

# Ensure Python can find the 'apps' package from the repo root
export PYTHONPATH="$REPO_ROOT"

QA_NAME="$QA_NAME" python3 -m apps.queue_automation.main