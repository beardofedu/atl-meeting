# Demo 01 — GHAS Autofix: XSS Alert on LogiTrack
**Section:** 05 | **Presenter:** Matt Desmond | **Duration:** ~17 min | **Format:** Browser (Security tab + code view)

---

## What This Demo Shows

A real GitHub Advanced Security CodeQL alert on the LogiTrack `app.js` — an unsanitized `innerHTML` assignment that reads from URL parameters, creating a reflected XSS vulnerability. Copilot Autofix generates a one-click fix. You apply it, commit it, and show the alert resolved.

**This is the "wow" moment for security audiences.** Take your time with it.

---

## The Vulnerability — Background

### What's in `app.js`

The vulnerable code pattern looks like this:

```javascript
// Carrier search — reads query param from URL, injects into DOM
const params = new URLSearchParams(window.location.search);
const searchQuery = params.get('q');

// ❌ VULNERABLE: unsanitized user input injected via innerHTML
document.getElementById('search-results-header').innerHTML =
  `Search results for: ${searchQuery}`;
```

### Why This Is a Problem

An attacker crafts a URL like:
```
https://logitrack.example.com/carriers?q=<img src=x onerror=alert(document.cookie)>
```

When a victim clicks that link:
1. The browser loads the page
2. `params.get('q')` returns the attacker's payload
3. `innerHTML` interprets it as HTML and executes the `onerror` handler
4. The attacker's script runs in the victim's browser session — session hijack, credential theft, data exfiltration

> "This isn't a theoretical attack. It's one of the most common vulnerabilities in web applications, and it's trivially exploitable. The only reason it doesn't get exploited constantly is that most people don't know to look for it."

### The Fix

Replace `innerHTML` with `textContent`:
```javascript
// ✅ SAFE: textContent never interprets HTML — it renders as literal text
document.getElementById('search-results-header').textContent =
  `Search results for: ${searchQuery}`;
```

If the content genuinely needs to render HTML (e.g., formatting), the correct fix is a sanitization library:
```javascript
// ✅ SAFE (HTML context): sanitize before injecting
import DOMPurify from 'dompurify';
document.getElementById('search-results-header').innerHTML =
  DOMPurify.sanitize(`Search results for: ${searchQuery}`);
```

Copilot Autofix will suggest `textContent` for this case (no formatting needed).

---

## Demo Script

### Step 1 — Set the Stage (2 min)

**Say:**
> "Before I show you the fix, let me show you how this vulnerability was found. We didn't have a security engineer audit this code. We didn't run a pen test. CodeQL found it automatically — on every push to the repo."

**Navigate to:** `github.com/<org>/logitrack/security/code-scanning`

**Say:**
> "This is the GitHub Advanced Security code scanning dashboard. Every alert CodeQL has found in the LogiTrack repo — sorted by severity."

**Point out:**
- The high-severity alert: "DOM-based cross-site scripting"
- The file and line: `app.js:47` (or wherever it is)

---

### Step 2 — Explore the Alert (4 min)

**Click the alert to open it.**

**Say:**
> "Let me walk you through what this alert is telling us."

**Point out each section:**

1. **Alert title:** "DOM-based cross-site scripting" — `js/xss`
2. **Severity:** High (CVSS 6.1)
3. **Rule description:** "Writing user-controlled data directly to a DOM element's innerHTML property allows arbitrary HTML/JavaScript injection."
4. **Data flow visualization:** Source → `window.location.search` → `URLSearchParams.get()` → `innerHTML`. CodeQL shows the path from the tainted input to the dangerous sink.

**Say:**
> "This is what makes CodeQL different from a pattern matcher. It's not looking for the string 'innerHTML' — it's tracing the data flow. It knows that `window.location.search` is user-controlled, follows that data through `URLSearchParams.get()` and a template literal, and flags it when it reaches `innerHTML`. That analysis would take a human reviewer significant time to reconstruct."

**Show the code highlight:**
- The vulnerable line is highlighted in red
- Source (the URL param) and sink (innerHTML) are both marked

---

### Step 3 — Explain the Attack Vector (3 min)

**Say:**
> "Let me make this concrete so it doesn't feel abstract."

**Open a new browser tab. Navigate to:**
```
[logitrack-demo-url]/index.html?q=<img src=x onerror=alert('XSS: session cookie = ' + document.cookie)>
```

*(Use the locally served version or a demo deployment. If not available, describe it instead.)*

**If you can load it live:**
> "Watch what happens when I load this URL..."
> *(Alert fires)* "That's an attacker's payload executing in the context of our LogiTrack application. That dialog could be exfiltrating session cookies to a server the attacker controls."

**If not loading live:**
> "If I were to load this URL — and I can show you this on your actual environment during a follow-up — that `onerror` handler would fire and execute the attacker's script in the victim's browser. Session cookies, auth tokens, anything the page has access to."

---

### Step 4 — Copilot Autofix (4 min)

**Switch back to the GHAS alert page.**

**Say:**
> "Here's where GitHub changes the economics of security. Not just finding the issue — fixing it."

**Click the "Generate fix" button** (or show the fix if already generated).

*(Wait 10–20 seconds for Autofix to generate.)*

**When the fix appears:**

**Say:**
> "Copilot Autofix has analyzed the alert. Here's what it's proposing."

**Show the diff:**
```diff
- document.getElementById('search-results-header').innerHTML =
-   `Search results for: ${searchQuery}`;
+ document.getElementById('search-results-header').textContent =
+   `Search results for: ${searchQuery}`;
```

**Say:**
> "The fix is exactly right: replace `innerHTML` with `textContent`. `textContent` never parses its input as HTML — it always renders as literal text. An attacker can inject whatever they want, and all the victim sees is the raw string. No script executes."

**Show the explanation Autofix provides:**
> "Notice it's not just the diff — it explains why this fixes the vulnerability. This is important for developers who aren't security experts: they understand the change, not just the patch."

---

### Step 5 — Apply and Commit (2 min)

**Click "Apply fix."**

**Say:**
> "One click. Copilot commits the fix directly — or opens a PR if you prefer that workflow. The alert is now marked as fixed pending the next scan."

**Show the commit / PR created by Autofix:**
- Commit message: "Fix DOM-based XSS: replace innerHTML with textContent in carrier search header"
- The alert status changes to "Fixed" (or pending next scan)

**Say:**
> "From alert to fix to commit — without leaving the browser, without filing a ticket, without scheduling a security sprint. The developer who introduced this bug might not have even known it was a bug. The platform found it and fixed it automatically."

---

### Closing the Demo (2 min)

**Say:**
> "This is one alert in one file. In a real enterprise codebase with hundreds of repos, GHAS runs on every one of them. Every push. Every PR. And Copilot Autofix resolves approximately 70% of the alerts it finds automatically. The other 30% are flagged for human review with the same data-flow analysis and fix suggestions."

> "Security teams stop being the last line of defense — because there are ten automated lines of defense before they even see the code."

---

## Fallback Assets

- Screenshot of the GHAS alert: save as `assets/screenshots/ghas-xss-alert.png`
- Screenshot of the Autofix diff: save as `assets/screenshots/ghas-xss-autofix-diff.png`
- The vulnerable code pattern is documented above — can be shown in VS Code if the GitHub UI has issues
