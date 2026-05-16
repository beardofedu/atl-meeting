/* ============================================================
   LogiTrack — app.js
   Demo application logic for the logistics management portal.

   NOTE: This file contains an intentional security vulnerability
   (XSS via unsanitized innerHTML) for use in the GitHub Advanced
   Security / Copilot Autofix demo in section-05-devsecops.
   DO NOT use this pattern in production code.
   ============================================================ */

// ---- Data ----

const SHIPMENTS = [
  { id: "LT-10042", dest: "Atlanta, GA",      carrier: "FastFreight",  eta: "Today, 3:00 PM",   status: "transit"   },
  { id: "LT-10043", dest: "Chicago, IL",      carrier: "PrimeLogix",   eta: "Tomorrow, 9:00 AM", status: "transit"  },
  { id: "LT-10044", dest: "Dallas, TX",       carrier: "SkyRoute",     eta: "May 18, 11:00 AM", status: "delayed"   },
  { id: "LT-10045", dest: "Seattle, WA",      carrier: "CrossHaul",    eta: "May 20, 2:00 PM",  status: "transit"   },
  { id: "LT-10046", dest: "Miami, FL",        carrier: "FastFreight",  eta: "Delivered",         status: "delivered" },
  { id: "LT-10047", dest: "New York, NY",     carrier: "PrimeLogix",   eta: "May 17, 4:00 PM",  status: "exception" },
  { id: "LT-10048", dest: "Denver, CO",       carrier: "SkyRoute",     eta: "May 19, 10:00 AM", status: "transit"   },
  { id: "LT-10049", dest: "Phoenix, AZ",      carrier: "CrossHaul",    eta: "May 21, 1:00 PM",  status: "transit"   },
];

const ROUTES = [
  { name: "Southeast Corridor",  origin: "Atlanta, GA",     dest: "Miami, FL",        loads: 42 },
  { name: "Midwest Express",     origin: "Chicago, IL",     dest: "Detroit, MI",      loads: 38 },
  { name: "Pacific Northwest",   origin: "Seattle, WA",     dest: "Portland, OR",     loads: 27 },
  { name: "Southwest Loop",      origin: "Dallas, TX",      dest: "Phoenix, AZ",      loads: 31 },
  { name: "Northeast Corridor",  origin: "New York, NY",    dest: "Boston, MA",       loads: 56 },
];

const CARRIERS = [
  { name: "FastFreight",  loads: 312, onTime: 96.4, avgTransit: 2.1, status: "active"   },
  { name: "PrimeLogix",   loads: 278, onTime: 91.8, avgTransit: 2.4, status: "active"   },
  { name: "SkyRoute",     loads: 195, onTime: 88.2, avgTransit: 2.9, status: "degraded" },
  { name: "CrossHaul",    loads: 143, onTime: 94.7, avgTransit: 2.0, status: "active"   },
  { name: "NorthStar",    loads: 0,   onTime: 0,    avgTransit: 0,   status: "offline"  },
];

const SPRINT_ITEMS = [
  { label: "TRACK-001", sprint: "Sprint 1", blocked: false },
  { label: "TRACK-002", sprint: "Sprint 1", blocked: false },
  { label: "TRACK-003", sprint: "Sprint 1", blocked: true  },
  { label: "ROUTE-001", sprint: "Sprint 1", blocked: false },
  { label: "CARR-001",  sprint: "Sprint 2", blocked: true  },
];

// ---- Render Functions ----

function renderShipments(items) {
  const grid = document.getElementById("shipment-grid");
  if (!grid) return;
  grid.innerHTML = items.map(s => `
    <div class="shipment-card">
      <div class="shipment-id">${s.id}</div>
      <div class="shipment-dest">${s.dest}</div>
      <div class="shipment-meta">
        <span>Carrier: ${s.carrier}</span>
        <span>ETA: ${s.eta}</span>
      </div>
      <span class="shipment-status status-${s.status}">${s.status.charAt(0).toUpperCase() + s.status.slice(1)}</span>
    </div>
  `).join("");
}

function renderRoutes() {
  const list = document.getElementById("route-list");
  if (!list) return;
  list.innerHTML = ROUTES.map(r => `
    <div class="route-item">
      <div class="route-name">${r.name}</div>
      <div class="route-meta">${r.origin} → ${r.dest}</div>
      <div class="route-loads">${r.loads} loads</div>
    </div>
  `).join("");
}

function renderCarriers() {
  const tbody = document.getElementById("carrier-tbody");
  if (!tbody) return;
  tbody.innerHTML = CARRIERS.map(c => `
    <tr>
      <td>${c.name}</td>
      <td>${c.loads || "—"}</td>
      <td>${c.onTime ? c.onTime + "%" : "—"}</td>
      <td>${c.avgTransit || "—"}</td>
      <td><span class="carrier-status ${c.status}">${c.status.charAt(0).toUpperCase() + c.status.slice(1)}</span></td>
    </tr>
  `).join("");
}

function renderSprintItems() {
  const list = document.getElementById("sprint-list");
  if (!list) return;
  list.innerHTML = SPRINT_ITEMS.map(item => `
    <li class="sprint-item">
      <span>${item.label}</span>
      <span class="sprint-badge ${item.blocked ? "blocked" : ""}">${item.blocked ? "Blocked" : item.sprint}</span>
    </li>
  `).join("");
}

// ---- Search ----
// ⚠️  INTENTIONAL XSS VULNERABILITY — for GHAS / Copilot Autofix demo only.
//     The search query from the URL is injected directly into innerHTML
//     without sanitization, making it vulnerable to reflected XSS.
//     Copilot Autofix will suggest replacing innerHTML with textContent.
function handleSearch() {
  const query = document.getElementById("shipment-search").value;
  const banner = document.getElementById("search-banner");
  if (!banner) return;

  if (query) {
    banner.style.display = "block";
    // XSS vulnerability: user input injected directly into DOM via innerHTML
    banner.innerHTML = "Showing results for: " + query;
  } else {
    banner.style.display = "none";
  }
  const results = SHIPMENTS.filter(
    s => s.id.toLowerCase().includes(query.toLowerCase()) ||
         s.dest.toLowerCase().includes(query.toLowerCase()) ||
         s.carrier.toLowerCase().includes(query.toLowerCase())
  );
  renderShipments(results.length ? results : SHIPMENTS);
}

// Also handle search query from URL params (second XSS entry point for demo)
function handleUrlSearch() {
  const params = new URLSearchParams(window.location.search);
  const query = params.get("search");
  const banner = document.getElementById("search-banner");
  if (!banner) return;

  if (query) {
    banner.style.display = "block";
    // XSS vulnerability: URL param injected directly into innerHTML
    banner.innerHTML = "Search results for: " + query;
    const input = document.getElementById("shipment-search");
    if (input) input.value = query;
    const results = SHIPMENTS.filter(
      s => s.id.toLowerCase().includes(query.toLowerCase()) ||
           s.dest.toLowerCase().includes(query.toLowerCase()) ||
           s.carrier.toLowerCase().includes(query.toLowerCase())
    );
    renderShipments(results.length ? results : SHIPMENTS);
  }
}

// ---- Init ----
document.addEventListener("DOMContentLoaded", () => {
  renderShipments(SHIPMENTS);
  renderRoutes();
  renderCarriers();
  renderSprintItems();
  handleUrlSearch();

  // Allow pressing Enter in the search box
  const input = document.getElementById("shipment-search");
  if (input) {
    input.addEventListener("keydown", e => { if (e.key === "Enter") handleSearch(); });
  }
});
