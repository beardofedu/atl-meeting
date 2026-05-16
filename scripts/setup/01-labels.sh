#!/usr/bin/env bash
# scripts/setup/01-labels.sh
# Creates all LogiTrack sprint and domain labels for the atl-meeting demo repo.
# Usage: bash scripts/setup/01-labels.sh <owner/repo>
# Example: bash scripts/setup/01-labels.sh beardofedu/atl-meeting

set -euo pipefail
REPO="${1:?Usage: $0 <owner/repo>}"

create_label() {
  local name="$1" color="$2" desc="$3"
  gh label create "$name" --color "$color" --description "$desc" --repo "$REPO" --force
}

echo "Creating domain labels…"
create_label "tracking"     "0075ca" "Package tracking and visibility features"
create_label "routing"      "e4e669" "Route optimization and planning"
create_label "carrier"      "d93f0b" "Carrier integration and management"
create_label "dispatch"     "0e8a16" "Dispatch and scheduling"
create_label "notifications" "bfd4f2" "Delivery and status notifications"
create_label "orders"       "f9d0c4" "Order management"
create_label "accounts"     "c5def5" "Account and customer management"
create_label "reporting"    "fef2c0" "Analytics and reporting"
create_label "platform"     "ededed" "Platform and infrastructure"
create_label "support"      "e99695" "Customer support tooling"

echo "Creating state labels…"
create_label "enhancement"  "a2eeef" "New feature or enhancement"
create_label "blocked"      "b60205" "Blocked by a dependency or external factor"

echo "Creating sprint labels…"
create_label "sprint-1"     "0052cc" "Sprint 1"
create_label "sprint-2"     "1d76db" "Sprint 2"
create_label "sprint-3"     "5319e7" "Sprint 3"
create_label "sprint-4"     "6f42c1" "Sprint 4"
create_label "sprint-5"     "8250df" "Sprint 5"

echo "✅ All labels created for $REPO"
