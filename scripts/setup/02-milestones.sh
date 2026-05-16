#!/usr/bin/env bash
# scripts/setup/02-milestones.sh
# Creates Sprint 1–5 milestones for the atl-meeting demo repo.
# Usage: bash scripts/setup/02-milestones.sh <owner/repo>

set -euo pipefail
REPO="${1:?Usage: $0 <owner/repo>}"

# Base: two weeks from today, each sprint adds 14 days
BASE=$(date -v +14d "+%Y-%m-%dT00:00:00Z" 2>/dev/null || date -d "+14 days" "+%Y-%m-%dT00:00:00Z")

add_days() {
  local base="$1" days="$2"
  date -v +${days}d -j -f "%Y-%m-%dT%H:%M:%SZ" "$base" "+%Y-%m-%dT00:00:00Z" 2>/dev/null \
    || date -d "$base + $days days" "+%Y-%m-%dT00:00:00Z"
}

DUE1="$BASE"
DUE2=$(add_days "$BASE" 14)
DUE3=$(add_days "$BASE" 28)
DUE4=$(add_days "$BASE" 42)
DUE5=$(add_days "$BASE" 56)

create_milestone() {
  local title="$1" due="$2" desc="$3"
  gh api "repos/$REPO/milestones" \
    --method POST \
    -f title="$title" \
    -f description="$desc" \
    -f due_on="$due" \
    --jq '.number' 2>/dev/null && echo " → $title"
}

echo "Creating sprint milestones for ${REPO}..."
create_milestone "Sprint 1" "$DUE1" "Core tracking and routing foundations"
create_milestone "Sprint 2" "$DUE2" "Authentication, accounts, and carrier onboarding"
create_milestone "Sprint 3" "$DUE3" "Promotions, order management, and search"
create_milestone "Sprint 4" "$DUE4" "Order history, notifications, and reviews"
create_milestone "Sprint 5" "$DUE5" "Support tooling, performance, and accessibility"

echo "✅ Milestones created for $REPO"
