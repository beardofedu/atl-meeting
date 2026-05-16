# Section 03 — Presenter Guide
**Presenter:** Chimnoy | **Time slot:** Afternoon session | **Duration:** ~20–30 min

---

## Pre-Event Checklist

- [ ] GitHub Actions workflow `sprint-impact-analysis.yml` exists in the LogiTrack repo
- [ ] At least one sample exception image in `assets/exceptions/` (use a generic box/package photo)
- [ ] GitHub Models or Azure OpenAI endpoint configured as an Actions secret (`AZURE_OPENAI_KEY` or `GITHUB_TOKEN` with Models access)
- [ ] A sample workflow run output ready to show (pre-run so the output log is available)
- [ ] Know the status of TRACK-003 — use it as the blocked-dependency example

---

## Run of Show — ~25 Minutes

| Time | Activity |
|---|---|
| 0:00–5:00 | Opening frame — unstructured data / what agents actually are |
| 5:00–12:00 | Sprint impact analysis demo — show the workflow, show the output |
| 12:00–20:00 | Image classification demo — show the workflow trigger, show the issue created |
| 20:00–25:00 | Connect to the broader story + Q&A |

---

## Demo Notes

### Sprint Impact Analysis
- Navigate to **Actions → sprint-impact-analysis** → click the most recent run
- Show the input (GitHub Project state, TRACK-003 blocked), the model call step, and the output markdown
- Navigate to the Discussion or Milestone comment where the report was posted
- **Key moment:** Show TRACK-003 flagged as a sprint blocker affecting 3 downstream issues

### Image Classification
- If running live: push a sample exception image to `assets/exceptions/` and watch the workflow trigger
- If not running live: show a pre-run workflow log and the resulting GitHub issue
- The issue should have: title "Package Exception: [damage type]", label `severity:medium`, body with the JSON classification and recommended action

---

## Transition Cues

**Into this section** (from working session):
> "The working session gave us a lot of good ground-level context. Before we get into governance, I want to show you where this is all heading — not just AI that assists developers, but agents that operate autonomously on your data. Chimnoy?"

**Out of this section** (to Section 05 DevSecOps):
> "So agents can process unstructured inputs, run on GitHub Actions, and produce structured outputs. The natural question is: how do you govern all of this? How do you make sure agents are operating within policy? That's exactly what Matt Desmond is going to cover next."

---

## Presenter Notes for Chimnoy

- **Lead with the problem, not the solution** — start with "most enterprise data is unstructured" before showing the workflow
- The TRACK-003 dependency example resonates because it was introduced in Section 01 — call back to it explicitly: "Remember TRACK-003 from the migration section? Here it is showing up in the sprint analysis as a blocker."
- If the live image classification demo takes too long: skip to showing the pre-generated issue. The concept lands without watching the workflow run live.
- Be ready for the question "what model is this using?" — answer: GitHub Models (powered by Azure OpenAI), runs with a GitHub token, no additional API keys required for Copilot Enterprise customers.
