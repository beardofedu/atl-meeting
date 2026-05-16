# Section 04 — Interactive Working Session
**Facilitated by:** Matt + Chikamso (+ Customer team) | **Time slot:** 1:00–2:30 PM | **Duration:** 90 min

---

## Purpose

Move from presentation to participation. This session gets the customer's engineering and platform teams talking — surfacing their specific context, constraints, and priorities — so the afternoon DevSecOps section and any follow-up work is calibrated to what actually matters to them.

---

## Opening Prompt (First 5 Minutes)

Facilitator says:

> "We've shown you the GitHub platform, Copilot, and agentic AI. Now we want to hear from you. We're going to spend the next 90 minutes in four areas — but before we structure it, one open question:"

> **"If you could change one thing about how your engineering teams build and ship software today, what would it be?"**

Let 2–3 people answer. Don't redirect yet. Just listen and note themes on the whiteboard.

Common answers to expect and how to frame them:
- *"We spend too much time on manual pipeline work"* → Maps to CI/CD modernization topic
- *"Our teams don't know what other teams are doing"* → Maps to GitHub Projects / unified visibility
- *"Security reviews slow everything down"* → Maps to GHAS + Copilot Autofix (Section 05)
- *"Onboarding new developers takes months"* → Maps to Copilot IDE + coding agent
- *"ADO is fragmented — nobody uses it the same way"* → Maps to migration strategy (reinforce Section 01)

---

## Four Topic Areas

Work through all four, spending ~15 min per topic. Adjust based on energy and discussion depth.

---

### Topic 1 — Intake → Backlog Automation

**Framing question:**
> "How does work get from a business request into your engineering backlog today? What's manual, what's fragile?"

**Discussion points to surface:**
- How are new feature requests submitted? Email, JIRA, ADO portal, Slack?
- Who does the translation from "business ask" to "engineering work item"?
- What gets lost in that translation?
- Where does sprint capacity vs demand misalignment happen?

**GitHub angle to introduce:**
- GitHub Issues + issue templates as a structured intake form
- The sprint impact analysis agent (from Section 03) as an automated backlog health check
- Copilot for GitHub Issues: "Help me break this feature request into sub-tasks" right on the issue

**Output to capture:**
- [ ] Current intake process described
- [ ] Pain points identified
- [ ] Interest level in GitHub Projects for backlog management

---

### Topic 2 — CI/CD Modernization

**Framing question:**
> "What does your CI/CD pipeline look like today, and where does it slow you down?"

**Discussion points to surface:**
- What percentage of builds are on ADO Pipelines vs other tools?
- Average build time? Average time from PR merge to production deploy?
- Where are the manual gates? (Approvals? Change management tickets?)
- Any compliance-driven hard stops in the pipeline?

**GitHub angle to introduce:**
- GitHub Actions: reusable workflows, composite actions, organization-level workflow templates
- Actions marketplace: 20,000+ pre-built actions for common tasks
- Required workflows: enforce org-wide security scans on every repo without per-team configuration
- Environments + deployment protection rules: replace change management gates with code-defined approval workflows

**Output to capture:**
- [ ] Current pipeline complexity level
- [ ] Change management / compliance requirements that affect pipeline design
- [ ] DORA metrics baseline if known (deployment frequency, lead time, MTTR, change failure rate)

---

### Topic 3 — GHEC + Copilot Adoption

**Framing question:**
> "How are you thinking about rolling out GitHub Enterprise Cloud and Copilot to your engineering organization?"

**Discussion points to surface:**
- How many engineers? What's the target rollout population?
- What does the procurement / approval process look like?
- Have any teams piloted Copilot already? What was their experience?
- What's the biggest internal concern about AI coding tools? (Security? IP? Quality? Job security?)

**GitHub angle to introduce:**
- Copilot seat management: assign by team, by role, by org — granular control
- Phased rollout playbook: pilot 50 → evaluate → expand
- Copilot metrics in GitHub Admin: acceptance rate, active users, suggested vs accepted lines
- Policy guardrails: feature toggles, content exclusions, model selection (covered in Section 05)

**Output to capture:**
- [ ] Target rollout size and timeline
- [ ] Internal approval stakeholders
- [ ] Key adoption concerns to address

---

### Topic 4 — Target Workflow Definition

**Framing question:**
> "If everything goes well — migration done, Copilot adopted, pipelines modernized — what does your 'ideal state' developer workflow look like 12 months from now?"

**Discussion points to surface:**
- What does a developer's Monday morning look like in the target state?
- What does the path from idea to production look like in the target state?
- What does "good" look like for security and compliance in that world?
- Who are the internal champions who will drive this? Who are the skeptics?

**GitHub angle to introduce:**
- Close the loop on the LogiTrack story from Section 02: this is the target workflow for a real enterprise developer
- DORA metrics as the measurement framework for "did we get there?"
- GitHub's Customer Success team: available for ongoing advisory as adoption progresses

**Output to capture:**
- [ ] Draft target-state workflow description (even rough)
- [ ] Named internal champions / pilot team candidates
- [ ] Top 3 blockers to getting there

---

## Capturing Outputs

**During the session:**
- Designate a note-taker (not the facilitator) — ideally someone from the GitHub team
- Use a shared Google Doc or whiteboard photo
- For each topic, capture: key pain points, GitHub angle that resonated, decisions or commitments made

**Before closing:**
> "Let me read back what I heard as the top three themes from this session..."

Land 3 themes. Get heads nodding. Transition to Section 05.

---

## Transition to Section 05

> "A thread that ran through every topic we just discussed was governance — who controls what, how do you know what's happening, how do you keep security teams comfortable while developers move fast. Matt Desmond is going to close us out with exactly that."
