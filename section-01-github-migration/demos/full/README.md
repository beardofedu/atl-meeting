# Full Demo — `gh migrate` Tooling & ADO Importer
**Section:** 01 | **Presenter:** Matt | **Duration:** ~15 min | **Format:** Terminal + browser

---

## What This Demo Shows

A live walkthrough of migrating repositories and projects from Azure DevOps to GitHub using GitHub's official migration tooling. Shows what migrates automatically, what needs manual attention, and how to validate a successful migration.

---

## Prerequisites

Everything below must be verified **before the demo session**.

### Tools Required

```bash
# GitHub CLI (must be 2.40+)
gh --version

# gh-migrate-project extension
gh extension install github/gh-migrate-project

# Confirm it's installed
gh extension list | grep migrate
```

### Authentication

```bash
# GitHub auth (with org SSO)
gh auth login --hostname github.com --scopes "repo,project,read:org"
gh auth status

# ADO PAT (stored as env var — never hardcode in scripts)
export ADO_PAT="<your-ado-personal-access-token>"
export ADO_ORG="<your-ado-org-name>"
export ADO_PROJECT="<your-ado-project-name>"
export GH_ORG="<your-github-org>"
```

> **Note for demo reset:** ADO PATs expire. Regenerate from `dev.azure.com/<org>/_usersSettings/tokens` and re-export before each demo session.

### Demo ADO Source

For this demo we use a pre-populated ADO project with:
- A small LogiTrack work item set (~15 items: Epics, User Stories, Tasks)
- Labels mapped to areas: `routing`, `tracking`, `carrier-mgmt`
- 2 sprints defined: Sprint 1 (completed), Sprint 2 (active)

---

## Demo Script

### Step 1 — Show the ADO Source State (3 min)

**Do:** Open the ADO demo environment in browser.

**Say:**
> "So here's what we're starting from — a typical ADO project. We've got a backlog with epics, user stories, tasks, two sprints, some completed work, some in flight. This is probably a lot smaller than what you'd see in a real migration, but it shows all the constructs."

**Highlight in ADO:**
- The work item hierarchy: Epic → User Story → Task
- Sprint 1 (closed) and Sprint 2 (active)
- A few items with custom tags / area paths

**Say:**
> "The question teams always ask is: what survives the migration? Let me show you."

---

### Step 2 — Run the Migration (5 min)

**Switch to terminal.**

```bash
# Step 2a: Export ADO project items to a migration manifest
gh migrate-project \
  --ado-org "$ADO_ORG" \
  --ado-project "$ADO_PROJECT" \
  --ado-pat "$ADO_PAT" \
  --output logitrack-migration.json

# Step 2b: Review the manifest (show what was captured)
cat logitrack-migration.json | jq '.items | length'
cat logitrack-migration.json | jq '.items[0]'
```

**Say while it runs:**
> "The migration manifest is a JSON file that describes every work item — title, description, state, assignee, sprint, custom fields, parent/child relationships. It's a checkpoint: you can inspect it, edit it, then import. You're not flying blind."

```bash
# Step 2c: Import to GitHub Project
gh migrate-project import \
  --manifest logitrack-migration.json \
  --github-org "$GH_ORG" \
  --project-title "LogiTrack - Sprint 2" \
  --map-states '{"To Do":"Backlog","In Progress":"In Progress","Done":"Done"}' \
  --map-users users.csv
```

**Say:**
> "The `--map-states` flag translates ADO states to GitHub Project statuses. The `--map-users` flag maps ADO email addresses to GitHub usernames — that CSV you prepare ahead of time."

**Expected output:**
```
✓ Creating GitHub Project "LogiTrack - Sprint 2"
✓ Importing 15 work items...
  ✓ ROUTE-001: Add route optimization summary panel
  ✓ TRACK-003: Carrier API Backend Integration
  ✓ SHIP-007: Bulk shipment CSV upload
  ... (12 more)
✓ Setting iteration fields (Sprint 1, Sprint 2)
✓ Migration complete. View: https://github.com/orgs/<org>/projects/<n>
```

---

### Step 3 — Validate in GitHub (4 min)

**Switch to browser, open the new GitHub Project.**

**Say:**
> "Let's see what we got."

**Walk through:**

1. **Items count** — confirm all 15 items imported
2. **Iteration field** — Sprint 1 and Sprint 2 are present
3. **Custom field mapping** — show that ADO tags became GitHub labels, area paths became a "Team" custom field
4. **One item in detail** — click TRACK-003, show title, description, original ADO ID preserved in description metadata

**Say:**
> "Notice the original ADO ID is preserved in the item description — `[ADO#4521]`. That's intentional. It's your audit trail: if someone asks 'where did this work item come from?' you can trace it back."

---

### Step 4 — What Migrates, What Doesn't (3 min)

**Say:**
> "I want to be transparent about what the tooling handles automatically and what requires manual attention."

| What Migrates | Status |
|---|---|
| Work item title & description | ✅ Automatic |
| State (with mapping) | ✅ With `--map-states` |
| Assignee (with mapping) | ✅ With `--map-users` |
| Sprint / iteration | ✅ Automatic |
| Tags → Labels | ✅ Automatic |
| Area path → custom field | ✅ Automatic |
| Parent/child hierarchy | ⚠️ Flattened (sub-issues in GitHub are beta) |
| Attachments | ⚠️ Links preserved, files need manual re-upload |
| Comments / history | ⚠️ First comment includes history summary |
| Test cases (ADO Test Plans) | ❌ Not migrated — no GitHub equivalent |
| Wiki pages | ✅ Separate tool: `gh migrate-wiki` |

**Say:**
> "The items that need manual attention are mostly edge cases. For teams that don't rely heavily on test plans or deep hierarchy, the migration is essentially automatic."

---

### Repo Migration Note

**Say:**
> "Work items are one half of the migration. For repo migration — git history, PRs, branches — GitHub has the ADO importer at `github.com/new/import`. That preserves full git history. PRs migrate with their comments and review history. I'm happy to demo that separately if useful, but it's essentially a URL + PAT away."

---

## Key Talking Points to Land

1. **Migration is not a big bang** — the JSON manifest lets you stage and validate before committing
2. **ADO IDs are preserved** — audit trail is intact, no black box
3. **State mapping is explicit** — you define how ADO states translate, nothing is assumed
4. **User mapping is your responsibility** — prepare the CSV ahead of time, it prevents orphaned assignments
5. **GitHub doesn't require you to abandon ADO history** — everything migrates with provenance

---

## Fallback / Recovery

If the live migration fails during the demo:
1. Have `logitrack-migration.json` pre-generated and committed to this repo
2. Run only Step 2c (import) from the pre-generated manifest
3. If import also fails: open the pre-migrated GitHub Project in the browser and walk through Steps 3–4 live
