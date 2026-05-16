# ATL Meeting — GitHub Copilot Demo Repository

> **GitHub Copilot demo repository for enterprise ADO → GitHub migration.**  
> All demos use **LogiTrack** — a fictional logistics management portal — as the shared demo story.

This repository contains presenter guides, talking points, and live demo scripts for each section of the day, organized by the meeting agenda. Matt's sections are marked ⭐.

---

## Meeting Agenda at a Glance

| Time | Section | Owner | Demo? |
|------|---------|-------|-------|
| 10:00 | Voice of the Customer Kick-off | Customer + Microsoft | — |
| 10:30 | **GitHub Migration Strategy** | ⭐ Matt | ✅ [`section-01`](./section-01-github-migration/) |
| 11:45 | **Unified SDLC + Dev Productivity with Copilot** | ⭐ Matt + Chikamso | ✅ [`section-02`](./section-02-unified-sdlc/) |
| 12:30 | Lunch | — | — |
| 13:00 | Working Session (Interactive) | All | 📋 [`section-04`](./section-04-working-session/) |
| 14:30 | Break | — | — |
| 14:45 | **DevSecOps + Advanced Security** | ⭐ Matt Desmond | ✅ [`section-05`](./section-05-devsecops/) |
| 15:45 | Wrap-up + Next Steps | All | — |

---

## The LogiTrack Demo Story

All demos use **LogiTrack** as the shared demo project — a static HTML/CSS/JS logistics management portal with a realistic sprint backlog.

### The Dependency Crisis (Section 02 + 03)
Issue **#3 TRACK-003** (Carrier API Backend Integration) is blocked in Sprint 1. Cancelling or delaying it triggers a cascade affecting 9 downstream issues across Sprints 2–4:

```
TRACK-003 (#3)
├── CARR-005 (#9)   — Carrier Onboarding Portal     [Sprint 2]
├── DISP-007 (#11)  — Dispatch Optimization Engine  [Sprint 3]
│   ├── DISP-008 (#12) — Load Tender Automation
│   └── DISP-009 (#13) — Capacity Planning Dashboard
└── ORD-001 (#14)   — Order Service Integration     [Sprint 3]
    ├── ORD-002 (#15)  — Order Confirmation Notifications
    ├── ACC-012 (#17)  — Order History [Sprint 4]
    │   └── OPS-009 (#18) — Return Shipment Processing
    ├── NOTIF-001 (#19) — Delivery Push Notifications
    └── REV-001 (#20)  — Carrier Performance Reviews
```

The `sprint-impact-analysis` GitHub Actions workflow detects this cascade automatically when TRACK-003 is closed as "not planned."

---

## Repository Structure

```
atl-meeting/
├── README.md
├── SETUP.md                          # One-time environment setup
├── .github/
│   ├── copilot-instructions.md       # LogiTrack conventions for the coding agent
│   ├── prompts/
│   │   └── inspect-delay.prompt.md  # Sprint impact analysis prompt template
│   └── workflows/
│       └── sprint-impact-analysis.yml
├── scripts/setup/
│   ├── 01-labels.sh
│   ├── 02-milestones.sh
│   ├── 03-issues.sh                  # 24 LogiTrack backlog issues
│   └── 04-projects.sh
├── demo-app/                         # LogiTrack static app
│   ├── index.html
│   ├── app.js
│   └── styles.css
├── section-01-github-migration/      ⭐ Matt
│   ├── PRESENTER-GUIDE.md
│   ├── talking-points.md
│   └── demos/
│       ├── light/    # GitHub Projects vs ADO Boards
│       └── full/     # gh migrate tooling
├── section-02-unified-sdlc/          ⭐ Matt + Chikamso
│   ├── PRESENTER-GUIDE.md
│   ├── talking-points.md
│   └── demos/
│       ├── 01-copilot-cli/
│       ├── 02-coding-agent/
│       ├── 03-code-review/
│       └── 04-ide/
├── section-03-agentic-ai/            Chimnoy
│   ├── PRESENTER-GUIDE.md
│   └── talking-points.md
├── section-04-working-session/       All
│   └── talking-points.md
└── section-05-devsecops/             ⭐ Matt Desmond
    ├── PRESENTER-GUIDE.md
    ├── talking-points.md
    └── demos/
        ├── 01-ghas-autofix/
        └── 02-enterprise-governance/
```

---

## Quick Setup

```bash
# 1. Clone the repo
git clone https://github.com/beardofedu/atl-meeting.git
cd atl-meeting

# 2. Create labels
bash scripts/setup/01-labels.sh beardofedu/atl-meeting

# 3. Create sprint milestones
bash scripts/setup/02-milestones.sh beardofedu/atl-meeting

# 4. Create 24 LogiTrack issues (run in a fresh repo)
bash scripts/setup/03-issues.sh beardofedu/atl-meeting

# 5. Create sprint project boards
bash scripts/setup/04-projects.sh beardofedu beardofedu/atl-meeting
```

See [`SETUP.md`](./SETUP.md) for the full setup guide including GHAS, GitHub Pages, and workflow verification.

---

## Quick Reference

| Term | What it means |
|------|--------------|
| **Copilot CLI** | `gh copilot` — natural language terminal assistant |
| **Coding Agent** | GitHub Copilot coding agent — autonomous, works on issues via GitHub Actions |
| **GHAS** | GitHub Advanced Security — secret scanning, CodeQL, Dependabot |
| **Autofix** | Copilot Autofix — AI-generated one-click fixes for GHAS alerts |
| **MCP** | Model Context Protocol — connects Copilot to external tools and data |
| **`copilot-instructions.md`** | `.github/copilot-instructions.md` — customizes Copilot's behavior for this repo |
| **sprint-impact-analysis** | Agentic GitHub Actions workflow that cascades alerts when an issue is cancelled |

---

*Demo repository — not for production use.*
