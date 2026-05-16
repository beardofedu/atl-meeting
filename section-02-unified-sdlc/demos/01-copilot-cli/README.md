# Demo 01 — Copilot CLI
**Section:** 02 | **Presenter:** Chikamso | **Duration:** ~10 min | **Format:** Terminal live demo

---

## What This Demo Shows

`gh copilot` in the terminal: two commands — `suggest` (generate a shell command from natural language) and `explain` (explain a shell command in plain English). Set in the context of a developer working with the LogiTrack repo.

**This demo has zero risk of failure** — it's two CLI commands with live AI responses. No repo state to break.

---

## Pre-Demo Setup

```bash
# Confirm gh copilot extension is installed
gh extension list | grep copilot
# Expected output: github/gh-copilot

# Confirm auth
gh auth status
# Expected: Logged in to github.com as <demo-user>

# Start in the repo root
cd ~/logitrack
```

Terminal font: 20pt. Light theme or high-contrast dark for readability.

---

## Demo Script

### Part 1 — `gh copilot suggest` (5 min)

**Say:**
> "I'm a developer who just cloned the LogiTrack repo. I want to spin up the local dev server and run the tests before I start on my issue. I know roughly what I want to do — I just don't remember the exact commands. In the past I'd dig through the README. Now I ask Copilot."

**Run:**
```bash
gh copilot suggest "start the local dev server for this project and open it in the browser"
```

**Expected interaction:**
```
? What kind of command do you want to run?
  1. Generic shell command
  2. gh command
  3. git command

> 1

Suggestion: npm run dev && open http://localhost:3000
? What would you like to do?
  1. Copy command to clipboard
  2. Explain command
  3. Execute command
  4. Revise command
  5. Exit

> 3
```

**Say as it runs:**
> "Copilot understood I wanted to start the server *and* open it — it combined two commands. Now let me try something more specific to the repo."

**Run:**
```bash
gh copilot suggest "find all JavaScript files in this repo that have an innerHTML assignment"
```

**Expected suggestion:**
```
grep -rn "innerHTML" --include="*.js" .
```

**Say:**
> "This is going to matter in a few minutes when we talk about security — but for now, let me show you the other half of this command."

---

### Part 2 — `gh copilot explain` (3 min)

**Say:**
> "The other command is `explain`. This is for the opposite scenario: you find a command somewhere — a runbook, a Stack Overflow answer, a colleague's script — and you want to understand what it does before you run it."

**Run:**
```bash
gh copilot explain "git log --oneline --graph --decorate --all --date=relative"
```

**Expected response (approximately):**
```
This command displays the git commit history with the following options:

• --oneline: Each commit on a single line (abbreviated hash + message)
• --graph: ASCII art tree showing branch/merge topology
• --decorate: Shows branch names and tags alongside commits
• --all: Includes all branches, not just the current one
• --date=relative: Shows commit times as "3 days ago" instead of timestamps

Together, this gives you a compact, visual overview of the full branch history
across all branches in the repository.
```

**Say:**
> "Plain English. No man page hunting, no Stack Overflow. This is particularly valuable for teams onboarding to GitHub Actions — those YAML pipeline files can have some gnarly shell steps."

**Run one more — a complex example:**
```bash
gh copilot explain "find . -name '*.js' -not -path '*/node_modules/*' | xargs grep -l 'require' | head -20"
```

**Say as it explains:**
> "This is the kind of one-liner that shows up in onboarding scripts and nobody knows who wrote it or what it does. Copilot explains it in under five seconds."

---

### Part 3 — Plant the Security Seed (1 min)

**Say:**
> "One more thing — remember that grep command for `innerHTML` we generated earlier? I'm going to run it now because it's going to come back in the DevSecOps section this afternoon."

**Run:**
```bash
grep -rn "innerHTML" --include="*.js" .
```

**If it finds results in `app.js`:**
> "There it is. That's an unsanitized `innerHTML` assignment — that's a potential XSS vector. We're going to let Copilot Autofix handle that automatically this afternoon. Keep that in mind."

**If no results** (repo doesn't have it yet):
> "Clean for now — but we've planted a flag. The DevSecOps section will show what happens when GHAS finds one of these."

---

## Key Talking Points to Land

1. **`suggest` is for developers who know what they want to do, not how to do it** — natural language → shell command
2. **`explain` is for humans who need to trust a command before running it** — shell command → plain English
3. **Both work in any shell, any OS** — it's a `gh` extension, not a VS Code plugin
4. **This is Copilot in the developer's native habitat** — the terminal — not just in the IDE
5. **It learns from conversation** — if the first suggestion isn't right, revise it in the same session
