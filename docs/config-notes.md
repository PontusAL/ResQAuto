# Config & .env notes

- **App variable**: `QA_NAME` (optional). If set, the app prints `Hello, $QA_NAME!`.
- **Precedence**:
  1. Docker: `deployments/docker/env/.env` is loaded by Compose, then passed to the container.
  2. macOS: export `QA_NAME` (or let `scripts/macos/run.sh` default to `MacUser`).
  3. CLI arg `--name` also works directly with `python -m apps.queue_automation.main --name X`.
- **Do not commit real env files**. Only commit `*.env.example`.