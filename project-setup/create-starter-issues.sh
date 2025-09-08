#!/usr/bin/env bash
set -euo pipefail

# --- helpers ---
ensure_milestone() {
  local title="$1"
  # If milestone with this title exists, do nothing; otherwise create it.
  local exists
  exists=$(gh api repos/:owner/:repo/milestones --jq '.[] | select(.title=="'"$title"'") | .number' || true)
  if [[ -z "$exists" ]]; then
    gh api repos/:owner/:repo/milestones -f title="$title" -f state=open >/dev/null
    echo "Created milestone: $title"
  else
    echo "Milestone exists: $title (#$exists)"
  fi
}

create_issue() {
  local title="$1" body="$2" labels="$3" milestone_title="$4"
  gh issue create \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$milestone_title" >/dev/null
  echo "Created: $title"
}

MS1_TITLE="Sprint 1 – Skeleton"
MS2_TITLE="Sprint 2 – Hello World"

echo "Ensuring milestones…"
ensure_milestone "$MS1_TITLE"
ensure_milestone "$MS2_TITLE"
echo

echo "Creating Sprint 1 issues…"

create_issue "Scaffold repo layout (apps + deployments + config + tests)" \
"**Why**  
Keep app logic separate from deployment specifics.

**Done when**  
- Folders exist:
  - \`apps/queue_automation/\` (with \`main.py\`)
  - \`deployments/docker/\`, \`deployments/macos/\`
  - \`config/\` (e.g., \`default.yaml\`)
  - \`tests/\`, \`docs/\`
- Top-level \`Makefile\` delegates to deployment Makefiles.
" \
"type:infra,priority:P1" "$MS1_TITLE"

create_issue "Minimal app entrypoint (deployment-agnostic)" \
"**Done when**  
- \`apps/queue_automation/main.py\` prints \`Hello, <name>!\`  
- Accepts \`--name\` or positional name.  
- Respects \`QA_NAME\` env var if present." \
"type:feature,priority:P1" "$MS1_TITLE"

create_issue "Docker deployment skeleton" \
"**Done when**  
- \`deployments/docker/Dockerfile\` (Ubuntu LTS base)  
- \`deployments/docker/docker-compose.yml\` with env file  
- \`deployments/docker/Makefile\` targets: \`build\`, \`run\`, \`sh\`  
- \`deployments/docker/env/.env.example\` (with \`QA_NAME=Ubuntu\`)." \
"ws:docker,type:infra,priority:P1" "$MS1_TITLE"

create_issue "macOS run targets" \
"**Done when**  
- \`deployments/macos/Makefile\` targets: \`run\`, \`run-name\` using system python3  
- (Optional) stub \`launchd\` plist path documented." \
"ws:macos,type:infra,priority:P1" "$MS1_TITLE"

create_issue ".env example and config notes" \
"**Done when**  
- \`.env.example\` at repo root or under each deployment  
- README explains env precedence and not committing real secrets." \
"type:infra,priority:P2" "$MS1_TITLE"

create_issue "README quickstart" \
"**Done when**  
- How to run Docker version (\`make docker/build\`, \`make docker/run\`)  
- How to run macOS version (\`make macos/run\`)  
- Repo layout explained briefly." \
"type:docs,priority:P2" "$MS1_TITLE"

echo
echo "Creating Sprint 2 issues…"

create_issue "Specify Hello World behaviour & interface" \
"**Done when**  
- \`docs/hello-world.md\` describes inputs (\`--name\`), env override (\`QA_NAME\`), exit codes, examples." \
"type:docs,priority:P1" "$MS2_TITLE"

create_issue "Implement Hello World (finalise CLI behaviour)" \
"**Done when**  
- \`apps/queue_automation/main.py\` matches spec in \`docs/hello-world.md\`  
- Prints exactly the specified output and returns exit code 0 on success." \
"type:feature,priority:P1" "$MS2_TITLE"

create_issue "Basic tests for Hello World" \
"**Done when**  
- Test asserts output and exit code for default and \`--name\`  
- Runnable via \`python3 -m pytest\` or a tiny custom test script." \
"type:feature,priority:P1" "$MS2_TITLE"

create_issue "Top-level Makefile targets" \
"**Done when**  
- \`make docker/build\`, \`make docker/run\`, \`make docker/sh\`  
- \`make macos/run\`, \`make macos/run-name\`  
- Targets call deployment Makefiles." \
"type:chore,priority:P2" "$MS2_TITLE"

echo
echo "All issues created ✅"