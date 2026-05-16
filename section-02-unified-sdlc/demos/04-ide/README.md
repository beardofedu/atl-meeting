# Demo 04 — VS Code with GitHub Copilot
**Section:** 02 | **Presenter:** Matt | **Duration:** ~6 min | **Format:** VS Code live demo

---

## What This Demo Shows

The developer-in-the-IDE experience: inline completions, Copilot Chat (Cmd+I inline), and Copilot Edits (multi-file). All in the context of the LogiTrack codebase — picking up where the coding agent's PR left off and polishing the implementation.

---

## Pre-Demo Setup

```bash
# Open VS Code with the LogiTrack workspace
cd ~/logitrack
code .
```

### VS Code Layout
- **Editor pane (left):** `app.js` open, scrolled to the `renderPanel()` function area
- **Explorer panel:** Visible with file tree
- **Copilot Chat panel:** Open on the right (Ctrl+Cmd+I or View → Copilot Chat)
- **Terminal:** Open at bottom (Ctrl+`)
- **Font size:** 18pt editor, 20pt terminal

### Copilot Status
- Check bottom status bar — Copilot icon should show as active (not spinning/error)
- If inactive: click the icon → Sign in → re-authorize

---

## Demo Script

### Part 1 — Inline Completions (2 min)

**Say:**
> "Let's start with the baseline — the thing everyone who uses Copilot knows. Inline completions."

**Open `app.js`. Navigate to a function — or type a new one:**

```javascript
// Type this and pause after the comment:
// Calculate carrier performance score based on on-time rate and volume
function calculateCarrierScore(
```

**Wait for the ghost-text completion to appear. Accept with Tab.**

**Say:**
> "Copilot is reading the function name, the comment, and the surrounding context from this file. The completion it suggested understands that 'carrier performance score' should probably involve the fields it's seen in other carrier functions in this file."

**Type another line inside the function:**
```javascript
  if (onTimeRate < 0.85) {
```

**Let Copilot complete the branch logic. Accept.**

**Say:**
> "Notice it suggested a reasonable threshold for the else branch. That's because it's read the rest of the codebase and inferred that 0.85 is our baseline threshold. It's contextually aware — not just autocomplete."

---

### Part 2 — Copilot Chat Inline (Cmd+I) (2 min)

**Select the `calculateCarrierScore` function you just wrote (or an existing function).**

**Press Cmd+I (Mac) / Ctrl+I (Windows) to open inline chat.**

**Type:**
```
Add JSDoc comments to this function explaining each parameter and return value
```

**Say while Copilot generates:**
> "Cmd+I opens Copilot Chat inline — right in the editor, not in a side panel. It modifies the selected code directly."

**Accept the result.**

**Try a second prompt — select a different block, Cmd+I:**
```
Refactor this to use early returns instead of nested if statements
```

**Say:**
> "This is where it goes beyond completion into actual refactoring. I'm giving it an instruction, it's rewriting the selected code to match. I can accept, reject, or ask it to try again."

---

### Part 3 — Copilot Edits (Multi-File) (2 min)

**Open the Copilot Edits panel** (View → Copilot Edits, or the Edits tab in the Copilot Chat pane).

**Say:**
> "The last thing I want to show is Copilot Edits — this is for changes that span multiple files. It's a multi-turn, multi-file editing session."

**Add files to the edit session:**
- Click "Add files" → add `app.js` and `index.html`

**Type in the Edits input:**
```
Add a loading spinner to the route-summary-panel that shows while routeData is being fetched. 
Use the existing spinner pattern from index.html if one exists, otherwise add a simple CSS spinner.
```

**Say while it generates:**
> "Copilot Edits is reading both files simultaneously. It knows the HTML structure in `index.html` and the JS logic in `app.js`. It's going to make coordinated changes to both."

**Show the diff for each file:**
- `index.html`: new spinner HTML inside the panel
- `app.js`: `showSpinner()` / `hideSpinner()` calls wrapping the data fetch

**Say:**
> "One instruction, two files updated, changes are coordinated. I can review each change independently, accept all, or reject individual hunks. This is the multi-file editing workflow."

---

## Key Talking Points to Land

1. **Three distinct surfaces** — inline completion (zero friction), inline chat (Cmd+I, surgical), Edits (multi-file, larger scope)
2. **Context awareness** — Copilot reads the whole workspace, not just the current file
3. **Developer stays in control** — accept, reject, or iterate on every suggestion
4. **Edits is the new paradigm** — this is what replaces "tell Copilot what to change and copy-paste from the chat window"
5. **The same codebase the agent touched** — we've gone full circle: issue → agent → PR review → IDE polish

---

## Closing the Section (Matt's Payoff Line)

**After Part 3:**

> "Let me tell you the story we just told in this section. A developer came in Monday morning. ROUTE-001 was in the backlog. They assigned it to the Copilot coding agent, grabbed a coffee, did the CLI work, and when they came back — there was a PR. Copilot had already reviewed it. They opened VS Code and polished it. That issue went from backlog to a reviewed, CI-passing pull request in under 30 minutes. That's the developer productivity story. That's what Copilot changes."
