# Section 02 — Presenter Guide
**Presenters:** Matt + Chikamso | **Slot:** 11:45 AM | **Total time:** ~45 min

---

## Pre-Event Checklist

Complete **night before** and again **30 min before**:

### Accounts & Auth
- [ ] GitHub.com logged in as demo account (not personal)
- [ ] `gh auth status` — confirm org SSO authorized
- [ ] VS Code open with LogiTrack workspace
- [ ] Copilot extension installed and active in VS Code (check bottom status bar)
- [ ] `gh copilot` extension installed: `gh extension list | grep copilot`

### LogiTrack Repo State
- [ ] Issue `ROUTE-001` exists and is **open**, assigned to no one (or yourself)
- [ ] Issue `TRACK-003` exists (Carrier API Backend Integration) — used as sprint dependency reference
- [ ] No stale branches named `copilot/route-001-*` (delete if present so agent creates fresh)
- [ ] `app.js` is in the state you want for the IDE demo (no pending edits)

### VS Code Setup
- [ ] Font size: 20pt terminal, 18pt editor (room projector)
- [ ] Split pane: left = `app.js`, right = Copilot Chat panel
- [ ] Terminal tab open, cwd = `~/logitrack`

### Fallback Assets
- [ ] Screenshot of a coding agent PR in `assets/screenshots/` (in case agent demo is slow)
- [ ] Pre-recorded 90-second screencast of coding agent run saved locally

---

## Run of Show — ~45 Minutes

| Time | Who | Activity | Demo |
|---|---|---|---|
| 0:00–5:00 | Matt | Opening frame — SDLC loop + Copilot in every phase | Slides / talking points |
| 5:00–8:00 | Matt | The AI progression table (2022 → 2025) | Slides |
| 8:00–10:00 | Matt | Introduce LogiTrack demo story — ROUTE-001 setup | Browser: show the issue |
| 10:00–20:00 | Chikamso | **Demo 1 — Copilot CLI** | `demos/01-copilot-cli/` |
| 20:00–32:00 | Matt | **Demo 2 — Coding Agent** | `demos/02-coding-agent/` |
| 32:00–37:00 | Chikamso | **Demo 3 — Code Review** | `demos/03-code-review/` |
| 37:00–43:00 | Matt | **Demo 4 — IDE (VS Code)** | `demos/04-ide/` |
| 43:00–45:00 | Both | Landing the payoff + transition to working session | — |

---

## Handoff Between Matt and Chikamso

**Matt intro → Chikamso (CLI demo):**
> "So let's make this concrete. Chikamso, you want to kick us off in the terminal?"

**Chikamso (CLI) → Matt (Coding Agent):**
> "...and that's the CLI story. Now Matt's going to show you what happens when you hand the issue to the agent itself."

**Matt (Coding Agent) → Chikamso (Code Review):**
> "The agent's done its work — here's the PR. Chikamso, you want to pull up the review?"

**Chikamso (Code Review) → Matt (IDE):**
> "So that's Copilot as reviewer. Now let's go back to the developer's IDE for the final mile."

---

## Timing Notes

- **Coding agent demo is time-sensitive** — the agent takes 3–8 min to open a PR after assignment. Start it during Demo 1 (CLI) so it's ready by the time Matt needs it.
- If running live: Chikamso assigns the issue at the START of the CLI demo, then Matt switches to the resulting PR at Demo 2.
- If running recorded: use the pre-recorded screencast for the agent run, then switch to live for PR review.

---

## Transition into Section 03

At the end of your 45 min:

> "We've shown you Copilot in the terminal, Copilot as a coding agent, Copilot reviewing PRs, and Copilot in VS Code. What we haven't talked about yet is what happens when you want to go even further — when you want agents operating on unstructured data, on images, on things that don't fit neatly into a GitHub issue. Chimnoy's going to take us there."

---

## Presenter Notes

**Matt:**
- Lead the narrative arc — you're the storyteller who makes all four demos feel connected
- Don't rush the "AI progression" table — it helps the audience understand *why* the coding agent is a big deal
- When the coding agent PR appears, let the room react — pause, let them read it

**Chikamso:**
- CLI demo: the `gh copilot explain` moment is usually the crowd-pleaser — pick a genuinely complex command
- Code review demo: click into a specific Copilot comment and explain *why* it flagged that line — don't just show the comments, interpret them
