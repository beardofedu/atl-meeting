#!/usr/bin/env bash
# scripts/setup/04-projects.sh
# Creates 5 sprint project boards linked to the atl-meeting demo repo.
# Requires: gh auth refresh -s project,read:project
#
# Usage: bash scripts/setup/04-projects.sh <owner> <owner/repo>

set -euo pipefail
OWNER="${1:?Usage: $0 <owner> <owner/repo>}"
REPO="${2:?Usage: $0 <owner> <owner/repo>}"

echo "Refreshing project OAuth scope…"
echo "If a browser window opens, enter the one-time code at https://github.com/login/device"
gh auth refresh -s project,read:project 2>/dev/null || true

create_project() {
  local title="$1"
  local project_id
  project_id=$(gh api graphql -f query="
    mutation {
      createProjectV2(input: {ownerId: \"$(gh api user --jq .node_id)\", title: \"$title\"}) {
        projectV2 { id number url }
      }
    }
  " --jq '.data.createProjectV2.projectV2.id' 2>/dev/null)
  echo "$project_id"
}

link_project() {
  local project_id="$1" repo_id="$2"
  gh api graphql -f query="
    mutation {
      linkProjectV2ToRepository(input: {projectId: \"$project_id\", repositoryId: \"$repo_id\"}) {
        repository { name }
      }
    }
  " > /dev/null 2>&1
}

REPO_ID=$(gh api "repos/$REPO" --jq '.node_id')
echo "Repo node ID: $REPO_ID"

for sprint in 1 2 3 4 5; do
  echo "Creating Sprint $sprint project board…"
  pid=$(create_project "LogiTrack Sprint $sprint")
  if [ -n "$pid" ]; then
    link_project "$pid" "$REPO_ID"
    echo "  ✅ Sprint $sprint board created and linked"
  else
    echo "  ⚠️  Sprint $sprint board creation failed — create manually via GitHub UI"
  fi
done

echo ""
echo "✅ Project boards done for $OWNER"
echo ""
echo "Next: Set Status and Priority values manually in each board's UI."
echo "Recommended status for Sprint 1:"
echo "  #1 TRACK-001 → In Progress / High"
echo "  #2 TRACK-002 → In Progress / High"
echo "  #3 TRACK-003 → Blocked / High   ← star of the demo"
echo "  #4 ROUTE-001 → Todo / Medium"
