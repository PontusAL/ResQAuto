#!/usr/bin/env bash
set -euo pipefail
PLIST="$HOME/Library/LaunchAgents/com.resqauto.hello.plist"
launchctl unload "$PLIST" 2>/dev/null || true
rm -f "$PLIST"
echo "launchd agent for queue automation removed."