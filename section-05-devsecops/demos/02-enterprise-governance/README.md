# Demo 02 — Enterprise Governance Controls
**Section:** 05 | **Presenter:** Matt Desmond | **Duration:** ~16 min | **Format:** Browser (GitHub Org Settings)

---

## What This Demo Shows

A walkthrough of GitHub Enterprise Cloud's governance controls for Copilot — feature toggles, model selection, IP protection, content exclusions, audit log, and seat management analytics. Aimed at security leads, compliance officers, and IT governance stakeholders.

**No code is written in this demo.** This is an admin/settings walkthrough.

---

## Pre-Demo Setup

- Logged in as **org owner** (required for all settings pages)
- Navigate to your LogiTrack demo org settings: `github.com/organizations/<org>/settings`
- Have these settings pages bookmarked (open in tabs):
  1. `settings/copilot/policies` — feature toggles
  2. `settings/copilot/content_exclusion` — content exclusions
  3. `settings/audit-log` — audit log
  4. `settings/billing/summary` — seat management / billing

---

## Demo Script

### Step 1 — Copilot Feature Toggles (3 min)

**Navigate to:** `Org Settings → Copilot → Policies`

**Say:**
> "This is the control plane for Copilot in your organization. Every Copilot feature has an explicit on/off toggle at the org level — and you can override them at the repository level for finer control."

**Walk through the toggles:**

| Toggle | What it controls |
|---|---|
| Copilot in the IDE | Inline completions and Chat in VS Code, JetBrains, etc. |
| Copilot Chat in GitHub.com | Chat on issues, PRs, code views on github.com |
| Copilot code review | The `@copilot` reviewer feature on PRs |
| Copilot coding agent | The autonomous issue → PR agent |
| Copilot in the CLI | `gh copilot suggest` and `gh copilot explain` |

**Say:**
> "If your security team isn't ready for the coding agent yet — one toggle. You can enable it for a pilot team and leave it off for everyone else. Same for any feature. This is not a binary 'Copilot on/off' decision — it's granular."

**Point out the per-team override:**
> "And if you want to enable the coding agent for your platform engineering team only — you can set the org default to 'disabled' and override it at the team level. Granularity all the way down."

---

### Step 2 — Model Selection (2 min)

**Still in Copilot Policies or navigate to model selection if it's a separate page.**

**Say:**
> "One question I always get: 'Which AI model is Copilot using? Can we choose?' Yes."

**Show the model selection options:**
- GPT-4o (default)
- Claude Sonnet (Anthropic)
- Gemini (Google)

**Say:**
> "You can set the default model for your org. Individual developers can switch models in their IDE. Some teams prefer Claude for code review reasoning, others prefer GPT-4o for completions. The choice is yours — GitHub isn't locked to one provider."

**Note for regulated industries:**
> "For customers in highly regulated industries who have existing Azure OpenAI agreements and data residency requirements, we have a path to bring your own endpoint. That's a separate conversation, but the option exists."

---

### Step 3 — IP Protection and Training Exclusion (3 min)

**Say:**
> "This is the question I get from every general counsel and every CISO: 'Is our code going to be used to train OpenAI's models?' Let me show you exactly where that's configured."

**Navigate to:** `Org Settings → Copilot → Policies` (or the "Suggestions matching public code" section)

**Point out:**

1. **Exclude from training toggle:**
   > "GitHub Enterprise Cloud customers are excluded from model training by default. Your code is not used to improve GitHub Copilot models. This is a contractual commitment, and this toggle is the config that enforces it."

2. **Duplicate code detection:**
   > "This filter prevents Copilot from suggesting code that closely matches publicly available code. It's a safeguard against accidentally including GPL-licensed code or other third-party content in your codebase."

3. **IP Indemnification:**
   > "GitHub Enterprise customers get IP indemnification for Copilot-generated code — as long as the duplicate detection filter is enabled. If a third party claims your Copilot-generated code infringes their IP, GitHub stands behind you legally. That's in the enterprise agreement."

---

### Step 4 — Content Exclusions (3 min)

**Navigate to:** `Org Settings → Copilot → Content exclusions`

**Say:**
> "Now — even with training exclusion and IP protection, you may have files in your repo that you never want Copilot to read. Proprietary algorithms. Compliance-sensitive configs. Environment files with key structures."

**Show the content exclusions config. Add an example if none exists:**

```
Pattern: **/*.env
Reason: Environment variable files — never use as Copilot context

Pattern: src/algorithms/proprietary/**
Reason: Trade-secret algorithms — exclude from Copilot context entirely

Pattern: compliance/audit-data/**
Reason: Regulated data — exclude from all AI processing
```

**Say:**
> "These patterns use glob syntax — same as `.gitignore`. Any file matching these patterns will not be read by Copilot, will not appear in completions, and will not be used as context for chat or agent sessions. Even if a developer has one of these files open in their IDE — Copilot ignores it."

**This is powerful for LogiTrack:**
> "For a logistics company, you might exclude your carrier rate negotiation algorithms, your fraud detection models, your customer data files. They live in the repo but Copilot never touches them."

---

### Step 5 — Audit Log for Copilot (3 min)

**Navigate to:** `Org Settings → Audit log`

**Filter by:** `action:copilot.*`

**Say:**
> "Every Copilot action is logged. Not at a summary level — at the individual action level."

**Show the log entries and explain each type:**

| Log action | What it records |
|---|---|
| `copilot.suggestion_dismissed` | Developer saw a suggestion, dismissed it |
| `copilot.suggestion_accepted` | Developer accepted a Copilot completion |
| `copilot.chat_message` | A Copilot Chat interaction (prompt + response hash) |
| `copilot.agent_run_started` | Coding agent began working on an issue |
| `copilot.agent_pr_opened` | Coding agent opened a pull request |
| `copilot.review_requested` | Copilot was requested as a PR reviewer |

**Say:**
> "If your compliance team asks 'what did Copilot do last Tuesday between 2pm and 4pm?' — you can answer that with this log. If there's ever a question about a specific PR — 'was this code Copilot-generated?' — it's in the audit trail."

**Show the streaming export:**
> "This log can be streamed in real-time to Splunk, Microsoft Sentinel, Datadog, or any SIEM via webhook or the streaming API. Your security operations team gets Copilot events in the same place they see everything else."

---

### Step 6 — Seat Management and Analytics (2 min)

**Navigate to:** `Org Settings → Billing → Copilot` (or the Copilot usage dashboard)

**Say:**
> "Last piece: how do you know whether Copilot is actually being used and delivering value?"

**Walk through the dashboard:**

1. **Active seats vs licensed seats** — "You've allocated 500 seats. 380 are active users in the last 30 days."

2. **Acceptance rate by team** — "The platform engineering team: 42% acceptance rate. The frontend team: 31%. Those are both healthy numbers — industry average is 30–40%."

3. **Editor usage** — VS Code 65%, JetBrains 25%, vim/neovim 10%

4. **Languages** — JavaScript 40%, Python 30%, Java 20%, other 10%

**ROI framing:**
> "380 active users at 35% acceptance rate, with Copilot suggesting roughly 500 lines per user per day — that's about 66,500 lines of code per day that developers didn't have to type. At even a conservative estimate of productivity recovered, that's a significant ROI. GitHub's internal research shows developers complete tasks 55% faster with Copilot on average."

**Say:**
> "This data lets you have the ROI conversation with leadership with real numbers, not just anecdotes."

---

## Closing the Demo

**Say:**
> "So: feature toggles give you granular control over what Copilot can do. Model selection lets you choose your AI provider. IP protection keeps your code yours. Content exclusions keep your sensitive files out of Copilot's context. The audit log gives your compliance team full visibility. And seat analytics give you the ROI story."

> "That's the full enterprise governance picture. Full power of agentic AI — with the control your security and compliance teams require."

---

## Settings Navigation Quick Reference

| Setting | URL pattern |
|---|---|
| Copilot feature toggles | `github.com/organizations/<org>/settings/copilot/policies` |
| Content exclusions | `github.com/organizations/<org>/settings/copilot/content_exclusion` |
| Audit log (Copilot filter) | `github.com/organizations/<org>/settings/audit-log?q=action%3Acopilot` |
| Seat management | `github.com/organizations/<org>/settings/billing/summary` |
| Copilot usage metrics | `github.com/organizations/<org>/insights/copilot/seats` |
