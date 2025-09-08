#!/usr/bin/env bash
set -euo pipefail
# Installs or updates the launchd agent for the current user using modern commands.

PLIST_SRC="deployments/macos/launchd/com.resqauto.hello.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.resqauto.hello.plist"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

mkdir -p "$HOME/Library/LaunchAgents" "$REPO_ROOT/logs"

# Substitute repo absolute path placeholders
sed "s#__REPO_ABS_PATH__#${REPO_ROOT}#g" "$PLIST_SRC" > "$PLIST_DEST"

# Validate plist format
/usr/bin/plutil -lint "$PLIST_DEST"

# Use modern launchctl workflow (bootstrap/bootout/enable/kickstart)
UID_NUM="$(id -u)"
LABEL="com.resqauto.hello"

# Unload any existing instance (ignore errors if not loaded)
launchctl bootout "gui/${UID_NUM}" "$PLIST_DEST" 2>/dev/null || true

# Load (bootstrap) the agent
launchctl bootstrap "gui/${UID_NUM}" "$PLIST_DEST"

# Ensure enabled
launchctl enable "gui/${UID_NUM}/${LABEL}"

echo "launchd agent for queue automation installed at: $PLIST_DEST"

# Optional: kickstart to run immediately (respects RunAtLoad too)
if [[ "${1:-}" == "--start" ]]; then
  launchctl kickstart -k "gui/${UID_NUM}/${LABEL}"
fi

# Show current status
launchctl print "gui/${UID_NUM}/${LABEL}" | sed -n '1,160p' || true