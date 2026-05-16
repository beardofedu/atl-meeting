# Section 05 — Presenter Guide
**Presenter:** Matt Desmond | **Slot:** 2:45 PM | **Total time:** ~60 min

---

## Pre-Event Checklist

Complete **night before** and again **30 min before**:

### GHAS Demo Setup
- [ ] LogiTrack `app.js` contains the XSS vulnerability (unsanitized `innerHTML` with URL param)
  - Verify: `grep -n "innerHTML" ~/logitrack/app.js` — should show the vulnerable line
- [ ] CodeQL scanning workflow enabled on the repo (`Settings → Code security → Code scanning → CodeQL`)
- [ ] At least one GHAS code scanning alert in the `Security` tab for the `innerHTML` XSS issue
  - If no alert: trigger a CodeQL scan: `Actions → CodeQL → Run workflow`
  - Wait ~5 min for results to appear in `Security → Code scanning`
- [ ] Copilot Autofix is **enabled** for the org: `Org Settings → Code security → Copilot Autofix → Enable`
- [ ] The XSS alert has an Autofix suggestion ready (the button "Generate fix" or "Apply fix" should be visible)
- [ ] Secret scanning alerts tab: at least one demo alert (or know that it's clean — either is fine)
- [ ] Dependency Review: a PR exists or have one ready to show the dependency review check

### Enterprise Governance Demo Setup
- [ ] Logged in as an org **owner** (not member) — required to show org-level settings
- [ ] Org Settings tabs pre-loaded:
  - `Settings → Copilot → Policies` — feature toggles
  - `Settings → Copilot → Content exclusions` — exclusions config
  - `Settings → Audit log` — filtered to Copilot events
  - `Settings → Billing → Copilot` — seat management dashboard
- [ ] Model selection configured (or know where the UI is)

### Screen / Environment
- [ ] Font size 20pt in browser zoom
- [ ] No personal accounts visible in browser history or tabs
- [ ] `talking-points.md` open on second screen as speaker notes

---

## Run of Show — ~60 Minutes

| Time | Activity | Demo |
|---|---|---|
| 0:00–7:00 | Opening — DevSecOps philosophy, cost-of-bugs table | Slides / talking points |
| 7:00–15:00 | GHAS overview — 3 pillars (no live demo yet) | Slides |
| 15:00–32:00 | **Live demo: GHAS Autofix on LogiTrack** | `demos/01-ghas-autofix/` |
| 32:00–37:00 | Copilot Autofix stats + "70%" talking point | Slides |
| 37:00–42:00 | Standard intake + governance model (ADO → GHEC) | Slides / talking points |
| 42:00–58:00 | **Live demo: Enterprise governance controls** | `demos/02-enterprise-governance/` |
| 58:00–60:00 | Closing pitch + open Q&A | — |

---

## Transition Cues

**Into this section** (from Section 03/04):
> "Thank you Chimnoy, and great discussion in the working session. I'm Matt Desmond — I lead on security and governance for our enterprise customers. And I want to close today by answering the question that every CISO I've met has asked..."

**Ending the session:**
> "We'll make sure you get the demo repo link, the GHAS configuration guide, and a follow-up email with the Copilot governance documentation. Thank you all for the time today — this has been a great session."

---

## Demo Recovery Plans

### GHAS alert not showing
1. Go to `Security → Code scanning → Scan history` — confirm CodeQL ran
2. If scan ran but no alert: manually navigate to the vulnerable line in `app.js` and explain what CodeQL would flag — the alert content is documented in `demos/01-ghas-autofix/README.md`
3. Fallback: use a screenshot of the alert (save one as `assets/screenshots/ghas-xss-alert.png`)

### Autofix button not present
1. Check `Org Settings → Copilot → Autofix` — must be enabled
2. If the fix isn't generated yet: click "Generate fix" and wait 20–30 seconds live (it's fast)
3. Fallback: walk through what the fix would be manually (textContent vs innerHTML) and explain the reasoning

### Governance settings not loading
1. Confirm you're logged in as org owner — member accounts won't see all settings
2. Have URLs pre-bookmarked so you can navigate directly without browsing
3. If Copilot settings are missing: your org may not have Copilot Enterprise enabled — use screenshots

---

## Notes for Matt Desmond

- **Security-skeptical audiences respond to honesty** — acknowledge that AI-generated code has risks, then show the controls that mitigate them. Don't oversell.
- **The "70% Autofix" stat is your most impactful number** — let it land before moving on
- **The Copilot audit log moment resonates with compliance officers** — "you can answer 'what did Copilot do last Tuesday?' with an API call"
- **TRACK-003 callback:** use it in the intake governance section — "when TRACK-003 is provisioned via self-service template, GHAS is on by default, CODEOWNERS is pre-configured, branch protection is enforced. Governance is built into the provisioning, not retrofitted."
- **Seat management ROI framing** is good for closing if there's a budget-holder in the room — have the math ready
