/* ============================================================
   LogiTrack Request Portal — app.js

   GitHub token is injected at deploy time by GitHub Actions.
   The placeholder __PORTAL_TOKEN__ is replaced by the deploy
   workflow using the PORTAL_GITHUB_TOKEN repository secret.
   ============================================================ */

const GITHUB_TOKEN = '__PORTAL_TOKEN__';
const REPO_OWNER   = 'beardofedu';
const REPO_NAME    = 'atl-meeting';

const LABEL_MAP = {
  feature:       ['enhancement', 'frontend'],
  bug:           ['bug'],
  performance:   ['performance', 'frontend'],
  security:      ['security', 'bug'],
  accessibility: ['accessibility'],
  chore:         ['chore'],
};

const PRIORITY_LABEL = {
  critical: 'priority: critical',
  high:     'priority: high',
  medium:   'priority: medium',
  low:      'priority: low',
};

// ── GitHub API helpers ────────────────────────────────────

async function ghFetch(path, options = {}) {
  const res = await fetch(`https://api.github.com${path}`, {
    ...options,
    headers: {
      Authorization: `Bearer ${GITHUB_TOKEN}`,
      Accept:        'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new Error(body.message || `GitHub API error ${res.status}`);
  }
  return res.json();
}

async function ghGraphQL(query, variables = {}) {
  const res = await fetch('https://api.github.com/graphql', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${GITHUB_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query, variables }),
  });
  const json = await res.json();
  if (json.errors) throw new Error(json.errors[0].message);
  return json.data;
}

// ── Load project boards into the dropdown ─────────────────

async function loadProjects() {
  const sel = document.getElementById('req-project');

  try {
    const data = await ghGraphQL(`
      query($owner: String!) {
        user(login: $owner) {
          projectsV2(first: 20, orderBy: { field: UPDATED_AT, direction: DESC }) {
            nodes { id number title }
          }
        }
      }
    `, { owner: REPO_OWNER });

    const projects = data.user.projectsV2.nodes;
    sel.innerHTML = '<option value="">— Select a project board —</option>';

    projects.forEach(p => {
      const opt = document.createElement('option');
      opt.value       = JSON.stringify({ id: p.id, number: p.number });
      opt.textContent = `#${p.number} ${p.title}`;
      sel.appendChild(opt);
    });
  } catch (err) {
    sel.innerHTML = '<option value="">⚠️ Could not load projects</option>';
    console.error('loadProjects:', err);
  }
}

// ── Create issue ──────────────────────────────────────────

async function createIssue(title, body, labels) {
  return ghFetch(`/repos/${REPO_OWNER}/${REPO_NAME}/issues`, {
    method: 'POST',
    body: JSON.stringify({ title, body, labels }),
  });
}

// ── Add issue to project board ────────────────────────────

async function addIssueToProject(issueNodeId, projectId) {
  const data = await ghGraphQL(`
    mutation($projectId: ID!, $contentId: ID!) {
      addProjectV2ItemById(input: { projectId: $projectId, contentId: $contentId }) {
        item { id }
      }
    }
  `, { projectId, contentId: issueNodeId });
  return data.addProjectV2ItemById.item.id;
}

// ── Set single-select field value on a project item ───────

async function setProjectField(projectId, itemId, fieldName, optionName) {
  // Fetch project fields
  const fieldsData = await ghGraphQL(`
    query($projectId: ID!) {
      node(id: $projectId) {
        ... on ProjectV2 {
          fields(first: 30) {
            nodes {
              ... on ProjectV2SingleSelectField { id name options { id name } }
            }
          }
        }
      }
    }
  `, { projectId });

  const fields = fieldsData.node.fields.nodes.filter(f => f.name);
  const field  = fields.find(f => f.name === fieldName);
  if (!field) return;

  const option = field.options?.find(o => o.name.toLowerCase() === optionName.toLowerCase());
  if (!option) return;

  await ghGraphQL(`
    mutation($projectId: ID!, $itemId: ID!, $fieldId: ID!, $optionId: String!) {
      updateProjectV2ItemFieldValue(input: {
        projectId: $projectId
        itemId: $itemId
        fieldId: $fieldId
        value: { singleSelectOptionId: $optionId }
      }) { projectV2Item { id } }
    }
  `, { projectId, itemId, fieldId: field.id, optionId: option.id });
}

// ── Build issue body from form values ─────────────────────

function buildIssueBody({ title, body, type, component, priority, submitter }) {
  const submitterLine = submitter ? `**Submitted by:** ${submitter}\n` : '';
  return `## Summary\n${body}\n\n` +
    `---\n\n` +
    `| Field | Value |\n` +
    `|---|---|\n` +
    `| **Type** | ${type} |\n` +
    `| **Component** | ${component} |\n` +
    `| **Priority** | ${priority} |\n` +
    (submitter ? `| **Submitted by** | ${submitter} |\n` : '') +
    `\n> 🤖 *This issue was created via the LogiTrack Request Portal. ` +
    `The AI Risk Assessor will evaluate and label this issue shortly.*`;
}

// ── Toast helper ──────────────────────────────────────────

function showToast(type, message, link = null) {
  const toast    = document.getElementById('toast');
  const icon     = document.getElementById('toast-icon');
  const msg      = document.getElementById('toast-msg');
  const linkEl   = document.getElementById('toast-link');

  toast.className = `toast toast--${type}`;
  icon.textContent = type === 'success' ? '✅' : '❌';
  msg.textContent  = message;

  if (link) {
    linkEl.href    = link;
    linkEl.hidden  = false;
  } else {
    linkEl.hidden  = true;
  }

  toast.hidden = false;
  clearTimeout(toast._timer);
  toast._timer = setTimeout(() => { toast.hidden = true; }, 8000);
}

// ── Form validation ───────────────────────────────────────

function validateForm(fields) {
  let valid = true;
  fields.forEach(id => {
    const el = document.getElementById(id);
    el.classList.remove('error');
    if (!el.value.trim()) {
      el.classList.add('error');
      valid = false;
    }
  });
  return valid;
}

// ── Submit handler ────────────────────────────────────────

async function handleSubmit(e) {
  e.preventDefault();

  const REQUIRED = ['req-title', 'req-type', 'req-component', 'req-priority', 'req-project'];
  if (!validateForm(REQUIRED)) {
    showToast('error', 'Please fill in all required fields.');
    return;
  }

  const title     = document.getElementById('req-title').value.trim();
  const type      = document.getElementById('req-type').value;
  const component = document.getElementById('req-component').value;
  const priority  = document.getElementById('req-priority').value;
  const body      = document.getElementById('req-body').value.trim();
  const submitter = document.getElementById('req-submitter').value.trim();
  const projectRaw = document.getElementById('req-project').value;

  let projectMeta;
  try { projectMeta = JSON.parse(projectRaw); }
  catch { showToast('error', 'Invalid project selection.'); return; }

  const submitBtn = document.getElementById('submit-btn');
  submitBtn.disabled = true;
  document.querySelector('.btn__text').hidden  = true;
  document.querySelector('.btn__spinner').hidden = false;

  try {
    // Build labels
    const typeLabels = LABEL_MAP[type] || [];
    const labels = [...typeLabels];

    // Create the issue
    const issueBody = buildIssueBody({ title, body, type, component, priority, submitter });
    const issue = await createIssue(
      `[${type.toUpperCase()}] ${title}`,
      issueBody,
      labels
    );

    // Add to project board
    const itemId = await addIssueToProject(issue.node_id, projectMeta.id);

    // Set project custom fields (best-effort — fields may not exist on all boards)
    await Promise.allSettled([
      setProjectField(projectMeta.id, itemId, 'Priority',  priority),
      setProjectField(projectMeta.id, itemId, 'Component', component),
      setProjectField(projectMeta.id, itemId, 'Type',      type),
    ]);

    showToast(
      'success',
      `Issue #${issue.number} created! The AI risk assessor will label it shortly.`,
      issue.html_url
    );
    document.getElementById('request-form').reset();

  } catch (err) {
    console.error('Submit error:', err);
    showToast('error', `Submission failed: ${err.message}`);
  } finally {
    submitBtn.disabled = false;
    document.querySelector('.btn__text').hidden  = false;
    document.querySelector('.btn__spinner').hidden = true;
  }
}

// ── Init ──────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  loadProjects();
  document.getElementById('request-form').addEventListener('submit', handleSubmit);
});
