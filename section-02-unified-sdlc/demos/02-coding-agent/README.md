# Demo 02 — Copilot Coding Agent
**Section:** 02 | **Presenter:** Matt | **Duration:** ~12 min | **Format:** Browser (GitHub.com + Actions)

---

## What This Demo Shows

Assigning a GitHub issue to the Copilot coding agent and watching it autonomously open a branch, implement the feature, and open a PR for human review. Uses issue **ROUTE-001: Add a route optimization summary panel** in the LogiTrack repo.

---

## Pre-Demo Setup

### Issue State
- `ROUTE-001` must be **open** and **unassigned** (or assigned to yourself)
- The issue body should contain a clear description — use this template if needed:

```markdown
## Summary
Add a route optimization summary panel to the carrier dashboard in `index.html`.

## Acceptance Criteria
- [ ] A new panel section appears below the existing carrier table
- [ ] The panel shows: total active routes, average delivery time, on-time percentage
- [ ] Panel uses the existing LogiTrack card/panel CSS styles
- [ ] Data is loaded from the mock `routeData` array already defined in `app.js`
- [ ] Panel updates when a carrier is selected from the dropdown

## Technical Notes
- Use existing `renderPanel()` pattern from `app.js`
- No new dependencies — vanilla JS only
- Panel ID should be `route-summary-panel`
```

### Repo State
- Delete any stale `copilot/*` branches: `git branch -r | grep copilot | ...`
- The `main` branch must have a passing CI run (Actions shows green)

### Timing Note
**⚠️ Start this demo during Demo 01 (CLI).** Assign the issue before Chikamso starts the CLI demo so the coding agent has 10 minutes to work. By the time Matt takes over, the PR should be open or nearly open.

---

## Demo Script

### Step 1 — Assign the Issue to Copilot (2 min)

**Open `ROUTE-001` on GitHub.com.**

**Say:**
> "Here's the issue: ROUTE-001, Add a route optimization summary panel. It's got clear acceptance criteria, a technical note about the existing patterns to follow. Now here's where it gets interesting."

**Do:**
- In the Assignees field on the right side: click the gear → type `copilot` → select **GitHub Copilot**

**Say:**
> "I'm assigning this issue to Copilot. Not to a human developer. To the AI agent."

- Click **Assign**

**Say:**
> "In a few seconds, GitHub Copilot is going to start working on this. It'll read the issue, explore the codebase, and open a pull request. Let me switch to Actions so we can watch."

---

### Step 2 — Watch the Agent Work in Actions (4 min)

**Navigate to:** `github.com/<org>/logitrack/actions`

**Say:**
> "The coding agent runs as a GitHub Actions workflow. You can watch every step — it's not a black box."

**Point out the workflow run:**
- Workflow name: `Copilot Coding Agent`
- Status: 🟡 In progress

**Click into the run and show the steps:**

| Step | What it shows |
|---|---|
| `Initialize agent` | Agent starting up, reading repo context |
| `Explore codebase` | Copilot reading relevant files: `app.js`, `index.html`, `styles.css` |
| `Plan implementation` | Agent outlining the changes it will make |
| `Implement changes` | Writing actual code |
| `Open pull request` | Creating the PR with a summary |

**Say:**
> "Notice it's exploring the codebase first. It's reading `app.js` to understand the `renderPanel()` pattern the issue mentioned. It's not guessing — it's reading the actual code."

**While waiting, pivot to talking:**
> "This is what we mean by the shift from AI assistance to AI as a team member. This agent has the same codebase context a human developer would have after a few days of onboarding. It knows the patterns, the conventions, the file structure."

---

### Step 3 — Review the Pull Request (5 min)

**When the PR is open, navigate to it.**

**Say:**
> "The PR is open. Let's see what Copilot actually built."

**Walk through the PR:**

1. **PR title and description** — Show that Copilot wrote a proper PR description explaining what it changed and why
2. **Files changed** — Show `index.html` (new panel HTML), `app.js` (new panel logic), possibly `styles.css`
3. **The implementation** — Click through to the diff, show the `route-summary-panel` div, the JS logic pulling from `routeData`

**Say:**
> "It followed the instructions. Panel ID is `route-summary-panel`. It used the existing `renderPanel()` pattern. Vanilla JS, no new dependencies."

4. **CI checks** — Show that the Actions checks are running (or passing) on the PR

**Say:**
> "The code goes through the same CI pipeline as any human PR. Copilot doesn't bypass the gate."

**Closing:**
> "Now — is this production-ready? Maybe. It needs human eyes. The acceptance criteria give you a checklist. But the first draft that would have taken a developer 2–3 hours? It's done in 8 minutes. Chikamso, let's look at the review."

---

## Key Talking Points to Land

1. **Issue quality determines agent quality** — clear acceptance criteria = better output. Garbage in, garbage out.
2. **The agent is transparent** — every step is logged in Actions; nothing is hidden
3. **It follows existing patterns** — the agent reads the codebase and respects the conventions it finds
4. **CI still runs** — the agent's PR goes through the same quality gates as human code
5. **Human review is still the final step** — the agent opens the PR, humans approve and merge
6. **TRACK-003 dependency** — if TRACK-003 (Carrier API) were blocked, the agent would still build the panel against the mock data; the real API wires in later. This is good parallel-work design.
