# Setup Guide — ATL Meeting Demo Environment

This guide covers the full one-time setup for the LogiTrack demo environment. Run these steps once before the meeting (or use the scripts in `scripts/setup/` to automate most of it).

---

## What Gets Created

| Artifact | Description |
|---|---|
| LogiTrack web app | Static HTML/CSS/JS logistics portal in `demo-app/` |
| 17 custom labels | Domain + sprint + state labels |
| 5 sprint milestones | Sprint 1–5 with 2-week intervals |
| 24 GitHub Issues | Realistic logistics backlog with `## Depends On` dependency links |
| 5 GitHub Project boards | One board per sprint |
| `sprint-impact-analysis` workflow | Auto-notifies blocked issues when a dependency is cancelled |
| `inspect-delay` prompt template | Reusable Copilot Chat prompt for ad-hoc impact analysis |

---

## Prerequisites

- **GitHub CLI** installed and authenticated: `gh auth login`
- **`gh copilot` extension**: `gh extension install github/gh-copilot`
- **Copilot Coding Agent** enabled: **Repo Settings → Copilot → Coding agent**
- **GitHub Advanced Security** enabled: **Settings → Code security → Enable GHAS**
- **GitHub Pages** enabled: **Settings → Pages → Branch: main / root**
- **GitHub Models** enabled (required for the AI narrative in the sprint impact workflow)

---

## Step 1 — Create Labels

```bash
bash scripts/setup/01-labels.sh beardofedu/atl-meeting
```

Creates 17 labels: domain labels (`tracking`, `routing`, `carrier`, `dispatch`, `notifications`, `orders`, `accounts`, `reporting`, `platform`, `support`), state labels (`enhancement`, `blocked`), and sprint labels (`sprint-1` through `sprint-5`).

---

## Step 2 — Create Sprint Milestones

```bash
bash scripts/setup/02-milestones.sh beardofedu/atl-meeting
```

Creates 5 milestones: Sprint 1–5 with 2-week due dates.

---

## Step 3 — Create Issues

> ⚠️ **Run this in a fresh repo with no existing issues.** Issue numbers must be sequential for the dependency graph to work.

```bash
bash scripts/setup/03-issues.sh beardofedu/atl-meeting
```

Creates all 24 issues with full body text, labels, and sprint milestone assignments.

### Issue Map

| # | Ticket | Sprint | Key Dependencies |
|---|---|---|---|
| 1 | TRACK-001 | 1 | — |
| 2 | TRACK-002 | 1 | #1 |
| 3 | **TRACK-003** | **1** | #2 · **Blocks #9, #11, #14** |
| 4 | ROUTE-001 | 1 | — |
| 5 | AUTH-001 | 2 | — |
| 6 | AUTH-002 | 2 | #5 |
| 7 | AUTH-003 | 2 | #5 |
| 8 | AUTH-004 | 2 | #5 |
| 9 | CARR-005 | 2 | #5, **#3** |
| 10 | ACC-006 | 2 | #5 |
| 11 | DISP-007 | 3 | #5, **#3** · Blocks #12, #13 |
| 12 | DISP-008 | 3 | #11 |
| 13 | DISP-009 | 3 | #11, #3 |
| 14 | ORD-001 | 3 | **#3**, #5 · Blocks #15, #17, #19, #20 |
| 15 | ORD-002 | 3 | #14 |
| 16 | SEARCH-001 | 3 | #4 |
| 17 | ACC-012 | 4 | #14, #5 · Blocks #18 |
| 18 | OPS-009 | 4 | #14, #17 |
| 19 | NOTIF-001 | 4 | #14 |
| 20 | REV-001 | 4 | #5, #14 |
| 21 | SUP-001 | 5 | — |
| 22 | SUP-002 | 5 | #5, #19 |
| 23 | PERF-001 | 5 | #4, #16 |
| 24 | A11Y-001 | 5 | — |

**The star of the show:** Closing #3 (TRACK-003) as "not planned" triggers the `sprint-impact-analysis` workflow, which automatically comments on and labels #9, #11, #14 (and transitively their dependents).

---

## Step 4 — Create Project Boards

```bash
bash scripts/setup/04-projects.sh beardofedu beardofedu/atl-meeting
```

Creates 5 sprint boards and links them to the repo. After running, set Status and Priority values manually in the GitHub Projects UI.

### Recommended initial assignments

| Issues | Status | Priority |
|---|---|---|
| #1, #2 | In Progress | 🔴 High |
| #3 | Blocked | 🔴 High |
| #4 | Todo | 🟡 Medium |
| #5, #6, #8 | Todo | 🔴 High |
| #7, #9, #10 | Todo | 🟡 Medium |
| #11, #14 | Todo | 🔴 High |
| #12, #17 | Blocked | 🔴 High |
| #13, #18 | Blocked | 🟡 Medium |

---

## Step 5 — Verify the Sprint Impact Workflow

1. Go to **Actions → Sprint Impact Analysis**
2. Confirm the workflow is enabled
3. Test: Close Issue #3 as "not planned"
4. Within ~60 seconds: issues #9, #11, #14 should receive impact alert comments and a `blocked` label
5. **Reset:** Re-open Issue #3, remove `blocked` labels, delete the impact comments

---

## Step 6 — Enable GitHub Pages

1. Go to **Settings → Pages**
2. Source: **Deploy from a branch** → Branch: `main` / `(root)`
3. Visit `https://beardofedu.github.io/atl-meeting/demo-app/` — LogiTrack should load
4. Test the XSS hook for the GHAS demo: append `?search=<img src=x onerror=alert(1)>` to the URL

---

## Step 7 — Verify GHAS / Autofix

1. **Settings → Code security** → Enable GitHub Advanced Security
2. **Settings → Code security** → Enable Copilot Autofix
3. After the first push, wait ~5–10 min for CodeQL to scan
4. **Security → Code scanning** → verify a `js/xss` alert on `demo-app/app.js`

If no alert appears, manually trigger: **Security → Code scanning → Set up more scanners → CodeQL → Run workflow**

---

## Pre-Meeting Checklist (30 min before)

- [ ] `gh auth status` — CLI authenticated as demo account
- [ ] `gh extension list | grep copilot` — `gh copilot` installed
- [ ] Issue #3 (TRACK-003) is open with `Blocked` status in Sprint 1 board
- [ ] Issues #9, #11, #14 have no `blocked` label (clean state for cascade demo)
- [ ] GHAS alert visible: **Security → Code scanning → `js/xss` on `app.js`**
- [ ] Copilot Autofix available on the alert (blue "Generate fix" button)
- [ ] An open issue exists for the coding agent demo (ROUTE-001 or similar)
- [ ] VS Code: Copilot extension active, LogiTrack repo open
- [ ] Browser: logged into demo GitHub account, Sprint 1 project board open in a tab
- [ ] Actions tab open in a second browser tab
- [ ] Font size 18pt+ in terminal, 140% zoom in VS Code
- [ ] Do Not Disturb enabled

---

## Resetting Between Demos

### Sprint Impact Cascade Reset
1. Re-open Issue #3 (TRACK-003) — click **Reopen issue**
2. Remove `blocked` label from issues #9, #11, #12, #13, #14, #15, #17, #18, #19, #20
3. Delete the sprint impact comments from those issues

### Coding Agent Reset
1. Close any open PRs labeled `demo`
2. Delete any `demo/*` branches
3. Re-open the target issue and remove any Copilot assignment
