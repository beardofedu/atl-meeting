# Section 03 — Agentic AI
**Presenter:** Chimnoy | **Time slot:** Afternoon (follows working session) | **Duration:** ~20–30 min

---

## Opening Frame

> "Everything we've shown so far has been about structured inputs: issues, PRs, code files. But most enterprise data isn't structured. Shipping manifests, carrier invoices, package photos, exception reports — they're PDFs, images, free-text emails. What happens when you put an AI agent in front of *that*?"

This section shows how GitHub Actions can host agentic workflows that go beyond code generation — processing unstructured inputs, making decisions, and feeding results back into the developer workflow.

---

## 1. What Is an Agentic Workflow?

Move beyond "Copilot suggests code" to "an agent takes action."

Key characteristics of an agentic workflow:
- **Perception:** reads unstructured inputs (images, PDFs, free-text)
- **Reasoning:** applies a model to understand and classify the content
- **Action:** takes a downstream step (creates an issue, updates a record, sends a notification, triggers another workflow)
- **Feedback loop:** the output feeds back into the system as structured data

> "An agent isn't just a smarter autocomplete. It's a process participant — something that can read, reason, and act."

---

## 2. GitHub Actions as an Agent Runtime

GitHub Actions is not just for CI/CD. It's a general-purpose **event-driven compute platform** that can host any agent workflow:

| Trigger | What fires the workflow |
|---|---|
| `push` / `pull_request` | Code changes (traditional CI) |
| `issues: opened` | New issue created |
| `workflow_dispatch` | Manual trigger with inputs |
| `schedule` (cron) | Timed batch processing |
| `repository_dispatch` | External webhook (any system) |

> "Any event that can hit a GitHub API endpoint can trigger an agentic workflow. A logistics system that emits a webhook when a package exception occurs? That webhook can kick off an agent that reads the exception, classifies it, and opens a prioritized issue — automatically."

---

## 3. The Sprint Impact Analysis Workflow

### What It Does
A GitHub Actions workflow (`sprint-impact-analysis.yml`) that:
1. **Triggers** on a schedule (end of sprint) or manually
2. **Reads** the current GitHub Project board state (open issues, blocked items, TRACK-003 dependency status)
3. **Calls an AI model** (via GitHub Models or Azure OpenAI) to analyze sprint velocity and predict at-risk items
4. **Outputs** a structured markdown report summarizing:
   - Items likely to slip
   - Blockers (e.g., TRACK-003: Carrier API Integration blocking downstream work)
   - Recommended re-prioritization
5. **Posts the report** as a comment on the sprint milestone or as a new GitHub Discussion

### Why This Matters

> "Your sprint retrospective report, written by an agent, available 5 minutes after the sprint closes. Not a dashboard you have to build — a narrative report that reads like a human wrote it."

**LogiTrack example:** TRACK-003 is blocked. The sprint impact agent detects that three other issues depend on TRACK-003 (including ROUTE-001's carrier data integration). It flags those as at-risk, estimates the slip, and recommends which items can be pulled forward as substitutes.

---

## 4. Unstructured Data Demo — Image Processing Agent

### The Scenario
Package exception images from carrier handoff points are uploaded to a GitHub repo's `assets/exceptions/` folder. An agent workflow triggers on `push` to that folder, reads each image using a vision model, classifies the damage type, and creates a structured GitHub issue with the damage classification and recommended action.

### The Agent Workflow (simplified)

```yaml
name: Package Exception Classifier
on:
  push:
    paths:
      - 'assets/exceptions/**'

jobs:
  classify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Classify exception images
        uses: actions/ai-inference@v1
        with:
          model: gpt-4o
          prompt: |
            Analyze the attached package exception image. 
            Classify the damage type (crushed, wet damage, missing label, open seal).
            Return JSON: { "type": "...", "severity": "low|medium|high", "recommended_action": "..." }
          files: ${{ github.event.commits[0].added }}

      - name: Create GitHub issue from classification
        uses: actions/github-script@v7
        with:
          script: |
            // Parse the model output and create a structured issue
```

**Say:**
> "The image comes in, the agent reads it, classifies the damage, and opens a structured issue — without a human touching it. The on-call engineer sees a triaged, classified issue instead of a raw image in a folder."

---

## 5. Key Talking Points

1. **Agents are process participants, not just code generators** — they read unstructured inputs and produce structured outputs
2. **GitHub Actions is the agent runtime** — event-driven, scalable, auditable, runs on GitHub's infrastructure
3. **The audit trail is built-in** — every agent action is a logged Actions run with full input/output history
4. **The data never leaves your control** — agents run in your GitHub org, against your data, using your model endpoints
5. **This is the next frontier** — teams that automate structured work with AI first will then automate unstructured work; the platform supports both

---

## 6. Connecting Back to the Broader Story

> "Earlier, Matt showed you how a developer's morning looks different when Copilot is writing the first draft of their code. What I'm showing you is how an *operations team's* morning looks different when agents are processing the overnight exceptions, analyzing the sprint, and handing humans a queue of already-classified, already-prioritized work. That's the agentic future — and it's running on GitHub Actions today."
