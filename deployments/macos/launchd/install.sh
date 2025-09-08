#!/usr/bin/env bash
set -euo pipefail
# Installs the launchd agent for the current user.

PLIST_SRC="deployments/macos/launchd/com.resqauto.hello.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.resqauto.hello.plist"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

mkdir -p "$HOME/Library/LaunchAgents" "$REPO_ROOT/logs"

# Replace placeholders with the repo absolute path
sed "s#__REPO_ABS_PATH__#${REPO_ROOT}#g" "$PLIST_SRC" > "$PLIST_DEST"

launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"
launchctl list | grep resqauto || true
echo "launchd agent for queue automation installed at: $PLIST_DEST"