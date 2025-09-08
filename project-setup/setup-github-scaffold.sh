#!/usr/bin/env bash
set -euo pipefail

# -------- helpers --------
require() { command -v "$1" >/dev/null || { echo "Missing $1. Please install it."; exit 1; }; }
require gh
require jq

# Repo + owner info
OWNER_LOGIN=$(gh repo view --json owner -q .owner.login)
REPO_FULL=$(gh repo view --json nameWithOwner -q .nameWithOwner)

echo "Owner (User): $OWNER_LOGIN"
echo "Repository:   $REPO_FULL"
echo

# Resolve the User node ID (user-only version)
USER_ID=$(gh api graphql -f query='query($login:String!){ user(login:$login){ id } }' -F login="$OWNER_LOGIN" --jq .data.user.id)

# -------- Labels --------
echo "Creating labels…"
make_label() { gh label create "$1" --color "$2" --description "$3" 2>/dev/null || true; }

make_label "ws:docker"    "0fb"     "Docker-deployed workstream"
make_label "ws:macos"     "5319e7"  "Mac-hosted workstream"
make_label "type:feature" "a33ea1"  "Feature work"
make_label "type:infra"   "0e8a16"  "Infrastructure"
make_label "type:docs"    "0366d6"  "Documentation"
make_label "type:chore"   "6a737d"  "Chore / maintenance"
make_label "priority:P1"  "d73a4a"  "High priority"
make_label "priority:P2"  "fbca04"  "Medium priority"
echo "✓ Labels ensured."
echo

# -------- Milestones --------
echo "Creating milestones…"
gh api repos/:owner/:repo/milestones -f title="Sprint 1 – Skeleton"     -f state=open >/dev/null || true
gh api repos/:owner/:repo/milestones -f title="Sprint 2 – Hello World"  -f state=open >/dev/null || true
echo "✓ Milestones ensured."
echo

# -------- Projects (user-level ProjectsV2) --------

# Create ProjectV2 under the user
create_project_v2 () {
  local title="$1"
  gh api graphql -f query='
    mutation($owner:ID!, $title:String!){
      createProjectV2(input:{ownerId:$owner, title:$title}){
        projectV2 { id title url }
      }
    }' -F owner="$USER_ID" -F title="$title"
}

# Get a user project by title (and include views)
get_user_project_v2 () {
  local title="$1"
  gh api graphql -f query='
    query($login:String!, $q:String!){
      user(login:$login){
        projectsV2(first:20, query:$q){
          nodes { id title url views(first:10){ nodes { id name } } }
        }
      }
    }' -F login="$OWNER_LOGIN" -F q="$title"
}

# Ensure project exists and set its first view filter
ensure_project_with_filter () {
  local title="$1"
  local filter="$2"

  # Try to find existing project
  local found=$(get_user_project_v2 "$title" | jq '.data.user.projectsV2.nodes[]? | select(.title=="'"$title"'")' || true)

  local project_id=""
  local project_url=""
  if [[ -z "$found" ]]; then
    echo "Creating Project: $title"
    local created=$(create_project_v2 "$title")
    project_id=$(echo "$created" | jq -r '.data.createProjectV2.projectV2.id')
    project_url=$(echo "$created" | jq -r '.data.createProjectV2.projectV2.url')
  else
    echo "Project exists: $title"
    project_id=$(echo "$found" | jq -r '.id')
    project_url=$(echo "$found" | jq -r '.url')
  fi

  # Re-fetch to get the current views (first view = default)
  local views=$(get_user_project_v2 "$title")
  local view_id=$(echo "$views" | jq -r '.data.user.projectsV2.nodes[] | select(.title=="'"$title"'") | .views.nodes[0].id')

  # Set the view filter (pre-filtered default view)
  # Example syntax: repo:owner/name label:'ws:docker'
  if [[ -n "$view_id" && "$view_id" != "null" ]]; then
    gh api graphql -f query='
      mutation($view:ID!, $filter:String!){
        updateProjectV2View(input:{projectViewId:$view, filter:$filter}){
          projectView { id }
        }
      }' -F view="$view_id" -F filter="$filter" >/dev/null || {
        echo "(!) Could not set filter automatically. Set this in the Project UI: $filter"
      }
  else
    echo "(!) Could not find a view to update. You can set the filter in the Project UI: $filter"
  fi

  echo "$title → $project_url"
}

echo "Ensuring Projects (user-level) with pre-filtered views…"
ensure_project_with_filter "Docker Deployed QA" "repo:$REPO_FULL label:'ws:docker'"
ensure_project_with_filter "Mac Hosted QA"     "repo:$REPO_FULL label:'ws:macos'"
echo "✓ Projects ensured."
echo
echo "Done ✅"