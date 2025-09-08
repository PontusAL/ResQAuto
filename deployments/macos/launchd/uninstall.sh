#!/usr/bin/env bash
set -euo pipefail

PLIST="$HOME/Library/LaunchAgents/com.resqauto.hello.plist"
UID_NUM="$(id -u)"
LABEL="com.resqauto.hello"

# Boot it out of the user GUI domain
launchctl bootout "gui/${UID_NUM}" "$PLIST" 2>/dev/null || true

# Remove the plist file itself
rm -f "$PLIST"

echo "launchd agent removed."