.
├─ apps/
│  └─ queue_automation/
│     ├─ __init__.py
│     ├─ main.py               # pure app entrypoint (no env-specific code)
│     ├─ core/                 # shared logic
│     └─ adapters/             # optional: OS/API adapters
├─ deployments/
│  ├─ docker/
│  │  ├─ Dockerfile
│  │  ├─ docker-compose.yml
│  │  ├─ Makefile              # build/run targets for docker only
│  │  └─ env/.env.example
│  └─ macos/
│     ├─ launchd/
│     │  └─ com.queue.automation.plist  # optional daemon
│     ├─ install_macos.sh               # optional helper
│     ├─ Makefile
│     └─ env/.env.example
├─ config/
│  ├─ default.yaml             # app config (deployment-agnostic)
│  └─ logging.ini
├─ tests/
├─ Makefile                    # thin delegator: `make docker/run`, `make macos/run`
├─ docs/
└─ README.md
