#!/usr/bin/env python3
"""
csv_to_github.py

Converts logitrack-project-planning.csv into GitHub Issues + a GitHub Project
with custom fields (Priority, Complexity, Component, Estimated Hours, Type).

Usage:
    cd <repo-root>
    python3 scripts/csv_to_github.py

Requirements:
    - gh CLI authenticated with 'repo' and 'project' scopes
    - Run from the repo root or any subdirectory
"""

import csv
import json
import os
import re
import subprocess
import sys

REPO          = "beardofedu/atl-meeting"
OWNER         = "beardofedu"
CSV_FILE      = "logitrack-project-planning.csv"
PROJECT_TITLE = "LogiTrack Roadmap"

LABEL_COLORS = {
    "accessibility": "0075ca",
    "carriers":      "d93f0b",
    "compliance":    "e4e669",
    "frontend":      "bfd4f2",
    "performance":   "f9d0c4",
    "routes":        "0e8a16",
    "security":      "b60205",
    "shipments":     "1d76db",
    "ui":            "ededed",
}


# ── Helpers ──────────────────────────────────────────────────────────────────

def gh(*args):
    """Run a gh CLI command. Returns (stdout_str, returncode)."""
    result = subprocess.run(["gh"] + list(args), capture_output=True, text=True)
    if result.returncode != 0 and result.stderr:
        _warn(result.stderr.strip())
    return result.stdout.strip(), result.returncode


def gql(query, **variables):
    """Run a GitHub GraphQL mutation/query. Returns parsed JSON data dict."""
    args = ["gh", "api", "graphql", "-f", f"query={query}"]
    for k, v in variables.items():
        args += ["-f", f"{k}={v}"]
    result = subprocess.run(args, capture_output=True, text=True)
    if result.returncode != 0:
        _err(f"GraphQL error: {result.stderr.strip()}")
        return {}
    parsed = json.loads(result.stdout) if result.stdout else {}
    if "errors" in parsed:
        _err(f"GraphQL errors: {parsed['errors']}")
    return parsed.get("data", {})


def _ok(msg):   print(f"  ✅  {msg}")
def _skip(msg): print(f"  ⏭️   {msg}")
def _info(msg): print(f"  ℹ️   {msg}")
def _warn(msg): print(f"  ⚠️   {msg}")
def _err(msg):  print(f"  ❌  {msg}", file=sys.stderr)


def ticket_id(title):
    """Extract ticket ID like TRACK-001 from an issue title."""
    m = re.search(r'\[([A-Z]+-\d+)\]', title)
    return m.group(1) if m else title


# ── Phase 1a: Labels ──────────────────────────────────────────────────────────

def create_labels():
    print("\n📌 Phase 1a — Labels")
    out, _ = gh("label", "list", "--repo", REPO, "--json", "name", "--limit", "200")
    existing = {l["name"] for l in json.loads(out)} if out else set()

    for name, color in LABEL_COLORS.items():
        if name in existing:
            _skip(f"label '{name}' already exists")
        else:
            _, rc = gh("label", "create", name, "--color", color,
                       "--repo", REPO, "--description", f"LogiTrack: {name}")
            if rc == 0:
                _ok(f"created label '{name}'  (#{color})")
            else:
                _err(f"failed to create label '{name}'")


# ── Phase 1b: Milestones ──────────────────────────────────────────────────────

def create_milestones(milestone_titles):
    print("\n🏁 Phase 1b — Milestones")
    out, _ = gh("api", f"repos/{REPO}/milestones",
                "--jq", "[.[] | {title: .title, number: .number}]")
    existing = {}
    for m in (json.loads(out) if out else []):
        existing[m["title"]] = m["number"]

    for title in milestone_titles:
        if title in existing:
            _skip(f"milestone '{title}' already exists (#{existing[title]})")
        else:
            out, rc = gh("api", f"repos/{REPO}/milestones",
                         "--method", "POST", "-f", f"title={title}")
            if rc == 0:
                num = json.loads(out).get("number")
                existing[title] = num
                _ok(f"created milestone '{title}' (#{num})")
            else:
                _err(f"failed to create milestone '{title}'")

    return existing  # {title: number}


# ── Phase 2a: Project ─────────────────────────────────────────────────────────

def create_project():
    print("\n🗂️  Phase 2a — GitHub Project")
    out, _ = gh("project", "list", "--owner", OWNER, "--format", "json", "--limit", "50")
    projects = json.loads(out).get("projects", []) if out else []

    for p in projects:
        if p["title"] == PROJECT_TITLE:
            _skip(f"project '{PROJECT_TITLE}' already exists (#{p['number']})")
            return p["number"], p["id"]

    out, rc = gh("project", "create", "--owner", OWNER,
                 "--title", PROJECT_TITLE, "--format", "json")
    if rc == 0:
        p = json.loads(out)
        _ok(f"created project '{PROJECT_TITLE}' (#{p['number']})")
        return p["number"], p["id"]

    _err("failed to create project")
    sys.exit(1)


# ── Phase 2b: Custom Fields ───────────────────────────────────────────────────

def create_project_fields(project_number):
    print("\n🔧 Phase 2b — Custom project fields")
    out, _ = gh("project", "field-list", str(project_number),
                "--owner", OWNER, "--format", "json", "--limit", "50")
    existing_fields = {f["name"]: f for f in json.loads(out).get("fields", [])} if out else {}

    # TEXT field
    if "Component" not in existing_fields:
        _, rc = gh("project", "field-create", str(project_number),
                   "--owner", OWNER, "--name", "Component", "--data-type", "TEXT")
        _ok("created field 'Component' (TEXT)") if rc == 0 else _err("failed 'Component'")
    else:
        _skip("field 'Component' already exists")

    # NUMBER field
    if "Estimated Hours" not in existing_fields:
        _, rc = gh("project", "field-create", str(project_number),
                   "--owner", OWNER, "--name", "Estimated Hours", "--data-type", "NUMBER")
        _ok("created field 'Estimated Hours' (NUMBER)") if rc == 0 else _err("failed 'Estimated Hours'")
    else:
        _skip("field 'Estimated Hours' already exists")

    # SINGLE_SELECT fields
    selects = [
        ("Priority",   "critical,high,medium,low"),
        ("Complexity", "small,medium,large"),
        ("Type",       "feature,bug,chore"),
    ]
    for name, options in selects:
        if name not in existing_fields:
            _, rc = gh("project", "field-create", str(project_number),
                       "--owner", OWNER, "--name", name,
                       "--data-type", "SINGLE_SELECT",
                       "--single-select-options", options)
            _ok(f"created field '{name}' (SINGLE_SELECT)") if rc == 0 else _err(f"failed '{name}'")
        else:
            _skip(f"field '{name}' already exists")

    # Re-fetch with fresh option IDs
    out, _ = gh("project", "field-list", str(project_number),
                "--owner", OWNER, "--format", "json", "--limit", "50")
    return json.loads(out).get("fields", []) if out else []


# ── Phase 3: Issues ───────────────────────────────────────────────────────────

def create_issues(rows):
    print("\n🐛 Phase 3 — GitHub Issues")
    out, _ = gh("issue", "list", "--repo", REPO, "--state", "all",
                "--json", "title,number,url", "--limit", "300")
    existing = {i["title"]: i for i in (json.loads(out) if out else [])}

    issue_map = {}  # ticket_id -> {number, url}

    for row in rows:
        title = row["title"]
        tid   = ticket_id(title)

        if title in existing:
            _skip(f"{tid} already exists (#{existing[title]['number']})")
            issue_map[tid] = existing[title]
            continue

        labels          = [l.strip() for l in row["labels"].split(",") if l.strip()]
        milestone_title = row["milestone"].strip()

        args = ["issue", "create", "--repo", REPO,
                "--title", title, "--body", row["body"]]
        for label in labels:
            args += ["--label", label]
        if milestone_title:
            args += ["--milestone", milestone_title]

        out, rc = gh(*args)
        if rc == 0:
            url = out.strip()
            match = re.search(r"/issues/(\d+)/?$", url)
            if not match:
                _err(f"could not parse issue number from: {url!r}")
                continue
            num = int(match.group(1))
            issue_map[tid] = {"number": num, "url": url}
            _ok(f"created {tid} → #{num}")
        else:
            _err(f"failed to create {tid}")

    return issue_map


# ── Phase 4a: Add to Project ──────────────────────────────────────────────────

def add_to_project(project_number, issue_map):
    print("\n➕ Phase 4a — Add issues to project")
    item_map = {}  # ticket_id -> project item node ID

    for tid, issue in issue_map.items():
        out, rc = gh("project", "item-add", str(project_number),
                     "--owner", OWNER, "--url", issue["url"], "--format", "json")
        if rc == 0:
            payload = json.loads(out) if out else {}
            item_id = payload.get("id", "")
            if not item_id:
                _err(f"no item id returned for {tid} — skipping field updates")
                continue
            item_map[tid] = item_id
            _ok(f"{tid} → item {item_id[:12]}…")
        else:
            _err(f"failed to add {tid} to project")

    return item_map


# ── Phase 4b: Set Field Values ────────────────────────────────────────────────

def set_field_values(project_id, item_map, rows, project_fields):
    print("\n✏️  Phase 4b — Set custom field values")

    field_lookup = {f["name"]: f for f in project_fields}
    row_lookup   = {ticket_id(r["title"]): r for r in rows}

    for tid, item_id in item_map.items():
        row = row_lookup.get(tid)
        if not row:
            continue

        assignments = [
            ("Component",       "text",         row["component"]),
            ("Estimated Hours", "number",        row["estimated_hours"]),
            ("Priority",        "singleSelect",  row["priority"]),
            ("Complexity",      "singleSelect",  row["complexity"]),
            ("Type",            "singleSelect",  row["type"]),
        ]

        for field_name, value_key, raw_value in assignments:
            if not raw_value:
                continue

            field = field_lookup.get(field_name)
            if not field:
                _warn(f"  field '{field_name}' not found — skipping")
                continue

            field_id = field["id"]

            if value_key == "singleSelect":
                options   = field.get("options", [])
                option_id = next(
                    (o["id"] for o in options if o["name"].lower() == raw_value.strip().lower()),
                    None
                )
                if not option_id:
                    _warn(f"  {tid}: option '{raw_value}' not found for '{field_name}'")
                    continue
                value_block = f"{{ singleSelectOptionId: \"{option_id}\" }}"

            elif value_key == "number":
                value_block = f"{{ number: {raw_value} }}"

            else:  # text — use json.dumps for safe quoting/escaping
                value_block = f"{{ text: {json.dumps(raw_value.strip())} }}"

            mutation = f"""
            mutation {{
              updateProjectV2ItemFieldValue(input: {{
                projectId: "{project_id}"
                itemId: "{item_id}"
                fieldId: "{field_id}"
                value: {value_block}
              }}) {{
                projectV2Item {{ id }}
              }}
            }}"""

            data = gql(mutation)
            if data.get("updateProjectV2ItemFieldValue"):
                _ok(f"  {tid}: {field_name} = {raw_value}")
            else:
                _err(f"  {tid}: could not set {field_name}")


# ── Phase 5: Link Repo ────────────────────────────────────────────────────────

def link_repo(project_number):
    print("\n🔗 Phase 5 — Link repository to project")
    _, rc = gh("project", "link", str(project_number),
               "--owner", OWNER, "--repo", REPO)
    if rc == 0:
        _ok(f"linked {REPO} → project #{project_number}")
    else:
        _skip("repo may already be linked (non-fatal)")


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    csv_path  = os.path.join(repo_root, CSV_FILE)

    print(f"🚀  LogiTrack CSV → GitHub")
    print(f"    repo:    {REPO}")
    print(f"    project: {PROJECT_TITLE}")
    print(f"    csv:     {csv_path}\n")

    if not os.path.exists(csv_path):
        _err(f"CSV not found at {csv_path}")
        sys.exit(1)

    with open(csv_path, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    _info(f"Loaded {len(rows)} work items from CSV")

    milestones = sorted({r["milestone"].strip() for r in rows if r["milestone"].strip()})

    # ── Run all phases ───────────────────────────────────────────────────────
    create_labels()
    milestone_map  = create_milestones(milestones)
    project_number, project_id = create_project()
    project_fields = create_project_fields(project_number)
    issue_map      = create_issues(rows)
    item_map       = add_to_project(project_number, issue_map)
    set_field_values(project_id, item_map, rows, project_fields)
    link_repo(project_number)

    print(f"\n🎉  All done! Your project is live:")
    print(f"    https://github.com/users/{OWNER}/projects")
    print(f"    https://github.com/{REPO}/issues\n")


if __name__ == "__main__":
    main()
