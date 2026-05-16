# Sprint Impact Analysis — Prompt Template
# Usage: Copy this template, fill in the blanks, and paste into Copilot Chat
# with this repository attached. Copilot will trace the dependency chain and
# produce a structured 5-section impact report.

---

## Sprint Impact Analysis Request

**Blocked issue:** #[ISSUE_NUMBER] — [TICKET_ID]: [ISSUE_TITLE]
**Scenario:** [cancelled | delayed N weeks | descoped]
**Current sprint:** [Sprint N]

Please analyze the full impact of this issue [not shipping / being delayed / being cancelled]:

1. **Blast Radius Table** — list every issue that directly or transitively depends on #[ISSUE_NUMBER], grouped by sprint. For each issue include: issue number, ticket ID, title, sprint, and whether it is directly or transitively blocked.

2. **Sprint-by-Sprint Impact** — for each affected sprint, summarize what can no longer ship and what is still unblocked.

3. **Critical Path** — identify the longest chain of dependent issues and estimate the minimum delay to the final deliverable if #[ISSUE_NUMBER] slips by [N] weeks.

4. **Recommendations** — provide 3 concrete actions the team could take to reduce the blast radius (e.g., stub the dependency, descope a feature, parallelize with a mock).

5. **Quick Wins** — identify any issues in the dependency chain that could still proceed independently (i.e., they have `## Depends On` entries but none of them are blocked by #[ISSUE_NUMBER]).

Use the issue bodies (specifically the `## Depends On` and `## Blocks` sections) as the source of truth for the dependency graph.

---

## Example (filled in for TRACK-003)

**Blocked issue:** #3 — TRACK-003: Carrier API Backend Integration
**Scenario:** cancelled (not planned this sprint)
**Current sprint:** Sprint 1

Please analyze the full impact of this issue not shipping…
