# Section 01 — Presenter Guide
**Presenter:** Matt | **Slot:** 10:30 AM | **Total time:** ~45 min

---

## Pre-Event Checklist

Complete these **the night before** and again **30 min before the session**:

### GitHub Setup
- [ ] Logged into `github.com` in Chrome (profile: Demo Account — not personal)
- [ ] LogiTrack org / repo open in a pinned tab: `github.com/<org>/logitrack`
- [ ] GitHub Project open in a second pinned tab (Board view pre-loaded)
- [ ] ADO demo environment open in a third pinned tab (Board + Backlog view)
- [ ] `gh` CLI authenticated: run `gh auth status` — confirm org SSO authorized
- [ ] `gh migrate` extension installed: run `gh extension list | grep migrate`

### Local Environment
- [ ] LogiTrack repo cloned at `~/logitrack` (or wherever your demo path is)
- [ ] Terminal open, cwd = repo root
- [ ] VS Code open with the LogiTrack workspace loaded
- [ ] Font size bumped to 20pt in VS Code and terminal (for screen share readability)

### Screen Share
- [ ] Close Slack, email, personal browser tabs
- [ ] Set display resolution to 1920×1080 or match room projector
- [ ] Disable notifications (macOS: Focus → Do Not Disturb)
- [ ] Have the `talking-points.md` open in a second window / monitor as speaker notes

---

## Run of Show — ~45 Minutes

| Time | Activity | Notes |
|---|---|---|
| 0:00–3:00 | **Opening frame** — fragmented ADO reality | No demo yet. Set context. |
| 3:00–8:00 | **Repos vs Work Tracking split** — whiteboard/slide | Draw the two columns. Land the "you don't have to migrate everything at once" point. |
| 8:00–20:00 | **Light demo** — GitHub Projects vs ADO Boards | See `demos/light/README.md` |
| 20:00–25:00 | **Phased migration strategy** — talk through 4 phases | Back to slides/talking points. |
| 25:00–40:00 | **Full demo** — `gh migrate` tooling | See `demos/full/README.md` |
| 40:00–45:00 | **Platform pitch + Q&A** | "GitHub is not just a code host." Land the three legs. Take 2–3 questions. |

---

## Transition Cues

**Into this section** (from opening/intro):
> "Alright, let's get into the meat of it. Matt, you want to kick us off with the migration strategy?"

**Handing off to Section 02** (after your Q&A):
> "So that's the migration story — how we get code and work tracking onto GitHub. The next question is: once you're there, what does the *developer experience* actually look like? Matt and Chikamso are going to walk us through that..."

---

## Demo Reset Steps

If something breaks mid-demo, here's how to recover fast:

### GitHub Projects demo goes wrong
1. Refresh the browser tab — Projects loads fast
2. If the custom field you added is missing: Settings → Fields → re-add
3. Fallback: switch to table view and narrate what you'd show

### `gh migrate` demo fails
1. Most likely cause: auth token expired — run `gh auth refresh --hostname github.com`
2. If the ADO PAT expired: have a screenshot/recording of the migration output as a fallback
3. The migration takes ~2 min on a real repo — if it's hanging, narrate what it's doing and cut to the output log file

### General fallback
- The `demos/light/README.md` and `demos/full/README.md` have screenshot-level descriptions
- You can narrate the flow from the README without running the live demo if needed

---

## Notes for Matt

- The ADO Boards comparison tends to get the most engagement from engineering managers — don't rush it
- The "honest nuance" about work item hierarchy (ADO > GitHub for hierarchy) builds credibility — say it proactively rather than waiting for someone to push back
- If anyone asks about GitHub vs Jira: acknowledge it's a different comparison, offer to follow up separately
- TRACK-003 (Carrier API Backend Integration) is the sprint dependency scenario used later in the DevSecOps section — you can plant the seed here when talking about cross-team dependencies in Projects
