# Section 01 — GitHub Migration Strategy
**Presenter:** Matt | **Time slot:** 10:30 AM | **Duration:** ~45 min

---

## Opening Frame

> "Before we talk about tooling, let's talk about where most enterprises actually are with ADO today."

Most large organizations that adopted ADO in the 2015–2020 window ended up with **fragmented project topology**: dozens (sometimes hundreds) of team projects, inconsistent branch policies, naming conventions that only made sense three reorg cycles ago, and no single pane of glass for engineering leadership.

GitHub migration is not a rip-and-replace. It's an **architectural decision** — and it starts with separating two concerns that ADO accidentally coupled together: **code hosting** and **work tracking**.

---

## 1. Repos vs Work Tracking — The Key Split

This is the most important framing to land early.

> "You don't have to migrate everything at once — and frankly, you shouldn't."

| Concern | ADO Today | GitHub Recommendation |
|---|---|---|
| Source code & PRs | ADO Repos | **Migrate first** — highest ROI, lowest risk |
| CI/CD pipelines | ADO Pipelines | Migrate to GitHub Actions (phased) |
| Work items / boards | ADO Boards | **Keep in ADO** during transition, or migrate to GitHub Projects |
| Test plans | ADO Test Plans | Evaluate — GitHub has no native equivalent yet |
| Artifacts | ADO Artifacts | GitHub Packages (NuGet, npm, Maven, Docker) |

**Key talking point:** "Repos and work tracking are independently migratable. Most teams get 80% of the value by starting with repos + Copilot enablement, without touching ADO Boards at all."

---

## 2. GitHub Projects vs Azure DevOps Boards

> "Let me show you what GitHub Projects actually is now — it's not the old GitHub Issues from 2019."

### GitHub Projects — What's Changed
- **Custom fields**: Text, number, date, single select, iteration — same field types as ADO work items
- **Views**: Board (kanban), Table (spreadsheet), Roadmap (Gantt-style timeline) — switch instantly
- **Automation**: Built-in GraphQL-powered automation rules (item added → set status, PR merged → close issue), plus Actions integration
- **Iteration fields**: First-class sprint support — define sprint cadences, assign items, filter by current/next sprint
- **Insights**: Burn-up/burn-down charts, cycle time, lead time — all native

### Side-by-Side Comparison

| Feature | GitHub Projects | ADO Boards Equivalent |
|---|---|---|
| Kanban board | ✅ Board view | ✅ Board view |
| Sprint planning | ✅ Iteration field + table filter | ✅ Sprints |
| Custom fields | ✅ (text, number, date, select, iteration) | ✅ (rich, incl. custom process templates) |
| Roadmap / timeline | ✅ Roadmap view (date fields) | ✅ Delivery Plans |
| Work item hierarchy | ⚠️ Flat (Issues + sub-issues in beta) | ✅ Epic → Feature → Story → Task |
| Automation | ✅ Built-in rules + Actions | ✅ Rules + Power Automate |
| Cross-repo issues | ✅ Native | ⚠️ Cross-project (complex setup) |
| Reporting / analytics | ✅ Insights (built-in) | ✅ Analytics views + Power BI connector |
| API | ✅ GraphQL | ✅ REST + OData |

**Honest nuance to address:** ADO's work item hierarchy (Epic → Feature → Story → Task) is richer than GitHub's current model. GitHub sub-issues are in beta and improving rapidly. For teams that depend heavily on that hierarchy, a hybrid approach (ADO Boards + GitHub Repos) is a legitimate interim state.

---

## 3. Migration Strategy — Phased Approach

> "The fastest way to fail a migration is to try to move everything at once for everyone."

### Recommended Phases

**Phase 1 — Pilot (Weeks 1–8)**
- Select 2–3 willing teams with greenfield or low-complexity repos
- Migrate repos using `gh migrate` tooling (preserve history, PRs, branches)
- Enable Copilot for pilot teams immediately — this is your "wow moment" driver
- Keep ADO Boards running; link GitHub PRs to ADO work items via AB#ID cross-linking

**Phase 2 — Broad Repo Migration (Months 2–6)**
- Scale repo migration using GitHub's ADO importer
- Establish org-level policies: branch protection, CODEOWNERS, required reviews
- Migrate CI/CD pipelines to GitHub Actions team-by-team (not all at once)
- Run ADO Boards + GitHub Projects in parallel for teams that want to experiment

**Phase 3 — Work Tracking Decision Point (Months 6–12)**
- Evaluate: are teams gravitating to GitHub Projects or staying on ADO Boards?
- For teams ready to move: run the project migration (items, labels, milestones)
- For teams staying on ADO: formalize the hybrid integration model

**Phase 4 — Governance & Standardization**
- Enterprise-wide branch policies, Copilot seat management, GHAS enablement
- Retire ADO Boards for fully migrated teams
- Measure: DORA metrics, Copilot acceptance rate, PR cycle time

---

## 4. The Platform Pitch

> "GitHub is not just a code host. It's a unified developer platform."

The three legs of the platform value story:

1. **Developer experience** — Copilot in the IDE, CLI, web; coding agent for autonomous work; code review AI
2. **Security** — GHAS built-in, not bolted on; Copilot Autofix closes alerts automatically
3. **Collaboration** — Issues, Projects, Discussions, wikis, Actions — the whole SDLC in one place

> "When a developer opens GitHub, they don't switch context. The issue they're working on, the branch they're coding on, the PR they're reviewing, the Actions run they're monitoring — it's all one surface. That's the productivity unlock."

---

## 5. Common Objections & Responses

| Objection | Response |
|---|---|
| "We have 500 ADO repos — migration is too risky" | "Start with 5. Prove the pattern. The tooling handles the rest." |
| "Our teams depend on ADO hierarchy" | "Hybrid is fine during transition. GitHub sub-issues are shipping. And most teams find flat Issues + Projects sufficient." |
| "GitHub Actions isn't as mature as Azure Pipelines" | "GitHub Actions has 20,000+ marketplace actions and runs more CI jobs per day than any other platform." |
| "What about compliance and audit trails?" | "GitHub Enterprise has audit log streaming, IP protection, SCIM, SSO — we'll cover that in Section 5." |

---

## Key Demo Reference
- Light demo: `demos/light/` — GitHub Projects vs ADO Boards comparison
- Full demo: `demos/full/` — `gh migrate` tooling walkthrough
