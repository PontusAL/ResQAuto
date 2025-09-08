#!/usr/bin/env bash
set -euo pipefail

sudo systemctl disable --now resqauto-hello.timer || true
sudo rm -f /etc/systemd/system/resqauto-hello.timer /etc/systemd/system/resqauto-hello.service
sudo systemctl daemon-reload
echo "Queue automation uninstalled."