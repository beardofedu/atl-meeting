# Light Demo — GitHub Projects vs ADO Boards
**Section:** 01 | **Presenter:** Matt | **Duration:** ~12 min | **Format:** Live browser walkthrough

---

## What This Demo Shows

A side-by-side comparison of GitHub Projects and Azure DevOps Boards using the **LogiTrack** sprint board as the live example. Goal: show that GitHub Projects has feature parity with ADO Boards for most engineering teams, and has key advantages in cross-repo visibility and Copilot integration.

**No setup required beyond a browser.** This demo requires no CLI, no local repo, no special permissions beyond org member access.

---

## Pre-Demo Setup (Do Before the Room Fills)

1. Open two browser windows side-by-side (or two monitors):
   - **Left:** ADO demo environment → Boards → LogiTrack sprint board
   - **Right:** `github.com/<org>/projects/<n>` → LogiTrack GitHub Project

2. Pre-load the GitHub Project in **Board view** (Kanban columns: Backlog, In Progress, In Review, Done)

3. Make sure the following items exist on the GitHub Project board:
   - `ROUTE-001`: Add route optimization summary panel *(In Progress)*
   - `TRACK-003`: Carrier API Backend Integration *(Blocked)*
   - `SHIP-007`: Bulk shipment CSV upload *(Backlog)*
   - At least one item linked to an open PR

4. Have the **Roadmap view** ready to switch to (one click)

---

## Demo Script

### Step 1 — Board View Overview (2 min)

**Say:**
> "Let me start with the thing everyone asks about: 'Does GitHub have a board?' Yes — here it is. This is our LogiTrack sprint board in GitHub Projects."

**Do:**
- Show the Kanban board with the LogiTrack items
- Click on `ROUTE-001` — show the side panel with: assignee, labels, linked PR, custom fields

**Highlight:**
- The linked PR shows its CI status (✅ or ❌) right in the card
- "In ADO, linking a PR to a work item is a separate step. Here it's automatic via the branch name."

---

### Step 2 — Custom Fields (2 min)

**Say:**
> "One of the things teams ask about most: 'Can we add custom fields?' Absolutely."

**Do:**
- Click the `+` column header → "New field"
- Show the field type picker: Text, Number, Date, Single select, Iteration

**Highlight:**
- Show the **Iteration** field type — "This is how you model sprints in GitHub Projects. Define your cadence once, assign items, filter by 'current iteration'."
- Show the **Single select** field with values like Priority: P0 / P1 / P2 — "Same as ADO's custom picklist fields."

**ADO comparison:**
> "In ADO this is done through Process Templates — it works, but it requires admin access and applies to the whole project. In GitHub Projects, any project owner can add custom fields in about 10 seconds."

---

### Step 3 — Table View (1 min)

**Say:**
> "Some folks prefer a spreadsheet view for sprint planning. One click."

**Do:**
- Switch to **Table view**
- Sort by Priority field
- Group by Iteration

**Highlight:**
- "This is what sprint planning looks like — drag items between iterations, bulk-edit fields inline."

---

### Step 4 — Roadmap View (2 min)

**Say:**
> "And for your engineering managers and PMs who need the timeline view — here's the roadmap."

**Do:**
- Switch to **Roadmap view**
- Show date fields on a few items (use Start Date / Target Date custom fields)
- Zoom in/out on the timeline

**ADO comparison:**
> "This is equivalent to ADO Delivery Plans — but it's built into every GitHub Project, not a separate extension you have to install."

---

### Step 5 — Automation (2 min)

**Say:**
> "Now here's where it gets interesting for teams that want to reduce process overhead."

**Do:**
- Open Project Settings → **Workflows**
- Show the built-in automations: "Item added to project → set Status to Backlog", "PR merged → set Status to Done"
- Enable one if it's not already on

**Highlight:**
- "These run on GitHub Actions under the hood — so you can extend them with any custom logic."
- "In ADO, this is done with Board Rules or Power Automate. GitHub keeps it simpler for the common cases."

---

### Step 6 — Cross-Repo Visibility (1 min)

**Say:**
> "Here's something ADO Boards doesn't do easily: one project that pulls issues from multiple repos."

**Do:**
- Show that the LogiTrack project has issues from two repos: `logitrack-web` and `logitrack-api`
- Filter by repo

**Highlight:**
- "If your teams have microservices split across repos, GitHub Projects gives you one board for all of them. In ADO you'd need cross-project queries or a separate team project."

---

### Closing the Demo (1 min)

**Say:**
> "So the short answer is: if your team is using ADO Boards today, everything you're doing there has a GitHub Projects equivalent. The Iteration field covers sprints, custom fields cover your metadata, the roadmap covers your timeline view, and automation covers your board rules. And you get Copilot context right on the issue — but we'll get to that in the next section."

---

## Comparison Reference Table

| GitHub Projects Feature | ADO Boards Equivalent | Notes |
|---|---|---|
| Board view | Board view | Parity |
| Table view | Backlog view | GitHub table is more flexible (sort/group by any field) |
| Roadmap view | Delivery Plans | ADO requires separate extension; GitHub built-in |
| Iteration field | Sprints | Parity. GitHub iterations are project-scoped |
| Custom fields (select, text, number, date) | Process template custom fields | GitHub: per-project, instant. ADO: org/project-wide, requires admin |
| Automation workflows | Board rules + Power Automate | GitHub built-in for common cases; extensible via Actions |
| Cross-repo issues | Cross-project queries | GitHub: native. ADO: complex queries, limited board views |
| PR → issue link (auto) | PR → work item link (manual AB#ID or branch policy) | GitHub auto-links via branch name convention |
| CI status on card | Not native on board | GitHub shows PR check status inline |
| Insights (burn-up, cycle time) | Analytics views | Both have charts; ADO has richer built-in reporting |
| API (GraphQL) | REST + OData | Both programmable; different query models |
