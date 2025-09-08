Create logs dir
`mkdir -p logs`
`bash deployments/macos/launchd/install.sh`
Optional: add `--start` to execute upon installation

Uninstall with:
`bash deployments/macos/launchd/uninstall.sh`

_error_? if it doesn't execute, run these as well:
```sh
chmod 755 scripts/macos/launchd_entry.sh
chmod 755 scripts/macos/run.sh
chmod 755 deployments/macos/launchd/install.sh
chmod 755 deployments/macos/launchd/uninstall.sh
```