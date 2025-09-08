#!/usr/bin/env bash
set -euo pipefail
# Installs/activates the systemd service + timer (requires sudo).

UNIT_DIR="/etc/systemd/system"
sudo cp deployments/linux/systemd/resqauto-hello.service "$UNIT_DIR/"
sudo cp deployments/linux/systemd/resqauto-hello.timer   "$UNIT_DIR/"

sudo systemctl daemon-reload
sudo systemctl enable --now resqauto-hello.timer

echo "Queue automation installed. Upcoming runs:"
systemctl list-timers --all | grep resqauto || true