# LogiTrack — Copilot Instructions
# This file customizes GitHub Copilot's coding agent behavior for the LogiTrack codebase.
# The coding agent reads this file before writing any code or opening a PR.

## Project Overview
LogiTrack is a logistics management portal built with plain HTML, CSS, and JavaScript (no build step, no framework).
It runs as a static site. All code lives in `demo-app/`.

## Tech Stack
- **Frontend:** Vanilla HTML5, CSS3 (custom properties, flexbox, grid), ES6+ JavaScript
- **No frameworks:** Do not introduce React, Vue, Angular, or any npm packages
- **No build tools:** No webpack, Vite, or bundlers — files are served as-is
- **Styling:** All styles in `demo-app/styles.css` using CSS custom properties defined in `:root`

## File Structure
```
demo-app/
├── index.html   — main page structure
├── app.js       — all application logic (data, render functions, event handlers)
└── styles.css   — all styles
```

## Coding Conventions

### JavaScript
- Use `const` and `let` — never `var`
- Use arrow functions for callbacks and short functions
- Use template literals for HTML generation in render functions
- Prefix render functions with `render` (e.g., `renderShipments`, `renderRoutes`)
- Data arrays at the top of `app.js` in `SCREAMING_SNAKE_CASE`
- Keep `app.js` organized in sections: Data → Render Functions → Event Handlers → Init

### Security
- **Never use `innerHTML` for user-supplied input** — use `textContent` instead
- Always validate and sanitize URL parameters before rendering

### CSS
- Use existing CSS custom properties from `:root` (e.g., `var(--color-primary)`, `var(--radius)`)
- Follow existing BEM-like class naming: `.component-name`, `.component-name__element`, `.component-name--modifier`
- Add new component styles after existing related styles, not at the end of the file

### HTML
- All interactive elements must have appropriate ARIA labels
- Use semantic HTML5 elements (`<main>`, `<section>`, `<aside>`, `<nav>`, `<header>`, `<footer>`)
- Maintain tab order and keyboard navigation

## What Good Issues Look Like
A well-scoped issue for the coding agent includes:
1. A clear feature name and one-sentence summary
2. Acceptance criteria as checkboxes
3. A `## Depends On` section (even if empty)
4. A `## Blocks` section (even if empty)

## PR Conventions
- PR title format: `[TICKET-ID] Brief description` (e.g., `[ROUTE-001] Add route optimization summary panel`)
- PR body should reference the issue number: `Closes #N`
- Keep changes focused on one issue — don't bundle unrelated changes

## Demo Notes
This repository is a live demo environment. The `app.js` file contains an intentional XSS
vulnerability (`innerHTML` with user input) for the GitHub Advanced Security demo. Do not
fix this automatically — it is intentional and documented.
