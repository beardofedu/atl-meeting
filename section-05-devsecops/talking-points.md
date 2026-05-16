# Section 05 — DevSecOps & Enterprise Governance
**Presenter:** Matt Desmond | **Time slot:** 2:45 PM | **Duration:** ~60 min

---

## Opening Frame

> "Everything we've shown today is powerful. Copilot is writing code, agents are opening PRs, pipelines are shipping fast. The question I always get from security teams is: 'That's great for developers — but how do I know it's safe? How do I maintain control?'"

> "The answer is: GitHub was designed from the ground up for this. Security is not a layer you add on top — it's built into every surface of the platform."

---

## 1. DevSecOps Philosophy

### Security as a Continuous Practice

The old model: **security as a gate**
- Code is written → security team reviews it → issues found → code sent back → delay → repeat

The GitHub model: **security as a continuous signal**
- Every push is scanned
- Every dependency is checked on introduction
- Every secret is detected before it lands in history
- Developers get fixes, not just alerts — often automated

> "The goal is to move security left — not to make it a blocker at the end, but to make it impossible to accidentally ship insecure code."

### The Cost of Finding Bugs Late

| Phase found | Relative cost to fix |
|---|---|
| In development (IDE) | 1x |
| In code review | 5x |
| In QA / staging | 15x |
| In production | 30x+ |

> "Copilot Autofix finding a bug at commit time costs you nothing. That same bug found by a pen tester in production costs you a lot."

---

## 2. GitHub Advanced Security (GHAS)

Three pillars:

### 2a. Secret Scanning

- Scans every commit, every branch, every PR for credentials, API keys, tokens, connection strings
- 200+ partner integrations: AWS, Azure, Google Cloud, Stripe, Twilio, GitHub tokens, etc.
- **Push protection:** blocks the push *before* the secret reaches the repo's history — not just alerting after the fact
- Custom patterns: define regex for your organization's internal secret formats

> "Push protection is the one that matters most. Detecting a secret after it's in git history is like detecting a fire after the building is ash. Push protection stops it before it's committed."

### 2b. Dependency Review

- Scans `package.json`, `requirements.txt`, `pom.xml`, `go.sum`, etc. on every PR
- Flags new vulnerable dependencies *before* they're merged — not after
- License risk detection: flag dependencies with incompatible licenses (GPL in a commercial product, etc.)
- Links to CVE database for context

> "This PR adds a new npm package. Dependency Review tells you in the PR if that package has a known CVE, before it's ever in your main branch."

### 2c. Code Scanning (CodeQL)

- Static analysis engine — analyzes code semantics, not just patterns
- Finds: SQL injection, XSS, path traversal, insecure deserialization, buffer overflows, and more
- Runs as a GitHub Actions workflow on every PR and on schedule
- Supports: JavaScript, TypeScript, Python, Java, C#, C/C++, Go, Ruby, Kotlin, Swift
- SARIF output integrates with any downstream SIEM or dashboard

> "CodeQL doesn't look for strings that look bad. It builds a semantic model of your code and understands data flow — where user input comes in and whether it can reach a sink without being sanitized. That's why it catches things grep-based tools miss."

---

## 3. Copilot Autofix

> "Here's the number that stops people in their tracks: approximately 70% of GHAS code scanning alerts are automatically resolvable by Copilot Autofix."

### How It Works

1. GHAS CodeQL finds an alert (e.g., unsanitized `innerHTML` in `app.js`)
2. Copilot Autofix analyzes the alert context, the vulnerable code, and the data flow
3. It generates a **one-click fix** — a code change that resolves the vulnerability
4. Developer reviews and applies the fix directly from the alert page — no branch switching, no manual patch
5. A new commit is created with the fix; the alert is resolved

### LogiTrack Demo Hook

The XSS vulnerability in `app.js` (unsanitized URL parameter injected via `innerHTML`) is the live demo case. Copilot Autofix will:
- Flag the alert: "DOM-based XSS: user-controlled data reaches a dangerous sink"
- Generate the fix: replace `.innerHTML = userInput` with `.textContent = userInput` (or proper sanitization for HTML contexts)
- Explain why: "Using `innerHTML` with unsanitized user input allows an attacker to inject arbitrary HTML/JavaScript via the URL"

> "The developer doesn't need to know the CVE number. They don't need to be a security expert. They click 'Apply fix' and it's done."

---

## 4. Standard Intake + Governance for ADO → GitHub Migration

### The Governance Model

For a large enterprise migrating from ADO to GitHub Enterprise Cloud, governance is the make-or-break factor. Propose a standard intake model:

**Repository Provisioning**
- New repos created via self-service template (repo template + org ruleset auto-applied)
- GHAS enabled by default on all new repos (no opt-in required)
- CODEOWNERS file required in template (at least one human reviewer per PR)
- Branch protection: require PR, require CI pass, no force push to main

**Team Onboarding**
- Teams provisioned via SCIM from your identity provider (AAD/Entra)
- SSO enforced at org level — no PATs for human auth
- Copilot seats assigned by team role (developers: yes; read-only stakeholders: no)
- IP protection and content exclusions configured at org level (details below)

**Audit and Compliance**
- Audit log streaming to SIEM (Splunk, Sentinel, Datadog — any streaming target)
- Copilot audit log: captures every Copilot suggestion accepted, every code review, every agent action
- Required workflows: security scan, dependency review — cannot be disabled by individual repos

---

## 5. Enterprise Governance — Copilot Controls

> "The question every enterprise security team asks: 'Is my code going to be used to train OpenAI's model?' The answer is no — and we can show you exactly where that's configured."

### Feature Toggles (Org Level)
- Enable/disable Copilot features at org or repo level: inline suggestions, chat, code review, coding agent
- Granular: you can enable inline completions for all developers but restrict the coding agent to a pilot group

### Model Selection
- Copilot Enterprise allows model selection: GPT-4o, Claude Sonnet, Gemini — choose per feature or per team
- Default is GPT-4o; switch to Claude for code review if preferred

### IP Protection
- **Exclude from training:** Copilot suggestions for your org are excluded from model training by default on GitHub Enterprise
- **Duplicate detection filter:** Copilot will not suggest code that matches public code above a threshold
- IP indemnification: GitHub indemnifies Copilot Enterprise customers against IP infringement claims on Copilot-generated code (with filter enabled)

### Content Exclusions
- Define file patterns or paths that Copilot should never use as context: `*.env`, `secrets/`, proprietary algorithm files
- Copilot will not read or suggest from excluded files — even if the file is open in the IDE

### Audit Log for Copilot
- Every Copilot action is logged: suggestions displayed, suggestions accepted, chat interactions, agent runs
- Available via the GitHub audit log API and streaming — searchable, exportable
- "If your compliance team asks 'what did Copilot do last Tuesday?' — you can answer that."

### Seat Management Analytics
- GitHub Admin dashboard: active users vs licensed seats, acceptance rates by team, adoption trends
- ROI framing: "You've licensed 500 seats. 380 are active. Acceptance rate is 38%. Based on GitHub's productivity data, that's approximately 1.5 engineer-years of productivity recovered per month."

---

## 6. The Closing Pitch

> "I want to close with something I say to every security team I talk to."

> "The choice isn't between 'AI-enabled development' and 'security.' Teams that move to AI-assisted development without governance are taking a risk. Teams that add governance-without-AI are falling behind their competitors. The only position that works long-term is: full power of agentic AI, with the control your security and compliance teams require. That's exactly what GitHub Enterprise gives you."

> "GHAS finds the vulnerabilities. Copilot Autofix fixes them — automatically. The audit log proves it happened. IP protection keeps your code yours. And your security team sleeps better than they did with ADO."

---

## Reference: Key Numbers to Use

| Metric | Value | Source |
|---|---|---|
| Copilot Autofix resolution rate | ~70% of GHAS alerts | GitHub data |
| Secret scanning partner patterns | 200+ | GitHub docs |
| Supported languages (CodeQL) | 10+ (JS, TS, Python, Java, C#, Go, Ruby, etc.) | GitHub docs |
| Copilot acceptance rate (avg) | 30–40% | GitHub survey |
| Cost to fix bug in production vs development | 30x | NIST / industry |
