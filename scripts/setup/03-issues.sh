#!/usr/bin/env bash
# scripts/setup/03-issues.sh
# Creates 24 LogiTrack sprint backlog issues for the atl-meeting demo repo.
# TRACK-003 (Carrier API Backend Integration) is the dependency-chain trigger.
#
# Usage: bash scripts/setup/03-issues.sh <owner/repo>
# ⚠️  Run in a fresh repo with no existing issues. Issue numbers must be sequential.

set -euo pipefail
REPO="${1:?Usage: $0 <owner/repo>}"

# Resolve milestone numbers by title
get_milestone() {
  gh api "repos/$REPO/milestones" --jq ".[] | select(.title==\"$1\") | .number"
}

echo "Resolving milestone IDs…"
MS1=$(get_milestone "Sprint 1")
MS2=$(get_milestone "Sprint 2")
MS3=$(get_milestone "Sprint 3")
MS4=$(get_milestone "Sprint 4")
MS5=$(get_milestone "Sprint 5")
echo "Sprint 1=$MS1, Sprint 2=$MS2, Sprint 3=$MS3, Sprint 4=$MS4, Sprint 5=$MS5"

create_issue() {
  local title="$1" body="$2" labels="$3" milestone="$4"
  gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$milestone" \
    2>/dev/null | tail -1
}

echo ""
echo "Creating Sprint 1 issues…"

create_issue \
  "TRACK-001: Real-Time Tracking API — Core Integration" \
  "## Overview
Integrate the core real-time tracking API to surface live shipment location and status data in the LogiTrack dashboard.

## Acceptance Criteria
- [ ] API client connects to tracking data source and returns current location + status
- [ ] Dashboard stat cards update on page load from live data
- [ ] Error handling for failed API calls (fallback to cached data)
- [ ] Unit tests cover happy path and network error cases

## Depends On
_None — foundational issue_

## Blocks
- #2 TRACK-002
- #3 TRACK-003" \
  "tracking,enhancement,sprint-1" "$MS1"

create_issue \
  "TRACK-002: Shipment Status Event Stream" \
  "## Overview
Build the status event stream layer on top of TRACK-001's API integration so real-time status changes (in-transit, delayed, delivered, exception) are pushed to the UI without a full page reload.

## Acceptance Criteria
- [ ] WebSocket or polling mechanism delivers status updates within 30 seconds
- [ ] Shipment cards update status badge without page refresh
- [ ] Connection loss is handled gracefully with reconnect logic

## Depends On
- #1 TRACK-001

## Blocks
- #3 TRACK-003" \
  "tracking,enhancement,sprint-1" "$MS1"

create_issue \
  "TRACK-003: Carrier API Backend Integration" \
  "## Overview
Integrate the carrier partner API backend to enable LogiTrack to communicate with external carriers (load tendering, status pulls, ETA updates). This is a foundational integration required by all carrier-dependent features.

## Acceptance Criteria
- [ ] OAuth2 authentication with carrier API gateway
- [ ] Load tender submission and acknowledgment flow working end-to-end
- [ ] ETA and status polling implemented with rate-limit handling
- [ ] Integration tests cover auth, tender, and status flows

## Depends On
- #2 TRACK-002

## Blocks
- #9 CARR-005 (Carrier Onboarding Portal)
- #11 DISP-007 (Dispatch Optimization Engine)
- #14 ORD-001 (Order Service Integration)" \
  "carrier,enhancement,sprint-1" "$MS1"

create_issue \
  "ROUTE-001: Route Optimization Summary Panel" \
  "## Overview
Add a route optimization summary panel to the dashboard that highlights the top 5 most efficient routes by cost-per-load, flagging routes with degraded performance.

## Acceptance Criteria
- [ ] Summary panel renders in the content area with route name, loads, and efficiency score
- [ ] Routes flagged as degraded display a visual indicator
- [ ] Panel is sortable by loads and efficiency score
- [ ] Accessible: ARIA labels, keyboard navigation

## Depends On
_None — uses static route data until TRACK-003 is complete_

## Blocks
- #16 ROUTE-002 (Dynamic Route Reoptimization)" \
  "routing,enhancement,sprint-1" "$MS1"

echo ""
echo "Creating Sprint 2 issues…"

create_issue \
  "AUTH-001: User Authentication — SSO Integration" \
  "## Overview
Implement Single Sign-On (SSO) authentication for LogiTrack portal users via the corporate identity provider.

## Acceptance Criteria
- [ ] SAML 2.0 / OAuth2 SSO flow working with identity provider
- [ ] Session management and token refresh implemented
- [ ] Logout clears session and redirects to IdP

## Depends On
_None_

## Blocks
- #6 AUTH-002
- #7 AUTH-003
- #8 AUTH-004
- #9 CARR-005
- #10 ACC-006" \
  "platform,enhancement,sprint-2" "$MS2"

create_issue \
  "AUTH-002: Role-Based Access Control (RBAC)" \
  "## Overview
Implement RBAC so dispatcher, carrier manager, and admin roles have appropriate access to LogiTrack features.

## Acceptance Criteria
- [ ] Three roles defined: Dispatcher, Carrier Manager, Admin
- [ ] UI conditionally renders features based on role
- [ ] API endpoints enforce role authorization

## Depends On
- #5 AUTH-001

## Blocks
_None_" \
  "platform,enhancement,sprint-2" "$MS2"

create_issue \
  "AUTH-003: Audit Log — User Action Tracking" \
  "## Overview
Log all significant user actions (login, load tender, route changes) to an audit trail for compliance and security review.

## Acceptance Criteria
- [ ] Audit log entries include: timestamp, user, action, entity ID
- [ ] Log is viewable by Admin role
- [ ] Retention policy: 90 days

## Depends On
- #5 AUTH-001

## Blocks
_None_" \
  "platform,enhancement,sprint-2" "$MS2"

create_issue \
  "AUTH-004: Multi-Factor Authentication (MFA)" \
  "## Overview
Add MFA support as an optional but org-enforceable security layer on top of SSO.

## Acceptance Criteria
- [ ] TOTP-based MFA flow implemented
- [ ] Admin can enforce MFA for all users in org settings
- [ ] Recovery codes generated at enrollment

## Depends On
- #5 AUTH-001

## Blocks
_None_" \
  "platform,enhancement,sprint-2" "$MS2"

create_issue \
  "CARR-005: Carrier Onboarding Portal" \
  "## Overview
Build a self-service carrier onboarding portal where new carriers can register, submit credentials, and be approved for load tendering in LogiTrack.

## Acceptance Criteria
- [ ] Carrier registration form with validation
- [ ] Admin approval workflow
- [ ] Onboarded carriers appear in carrier performance table

## Depends On
- #5 AUTH-001
- **#3 TRACK-003** ← _blocked until Carrier API backend is live_

## Blocks
_None_" \
  "carrier,enhancement,sprint-2" "$MS2"

create_issue \
  "ACC-006: Customer Account Management" \
  "## Overview
Build account management screens so customers can view their shipping history, update contact information, and manage notification preferences.

## Acceptance Criteria
- [ ] Account profile page with editable fields
- [ ] Shipping history table with pagination
- [ ] Notification preference toggles (email, SMS, webhook)

## Depends On
- #5 AUTH-001

## Blocks
_None_" \
  "accounts,enhancement,sprint-2" "$MS2"

echo ""
echo "Creating Sprint 3 issues…"

create_issue \
  "DISP-007: Dispatch Optimization Engine" \
  "## Overview
Build the dispatch optimization engine that automatically assigns loads to available carriers based on route, capacity, and cost constraints.

## Acceptance Criteria
- [ ] Optimization algorithm assigns loads minimizing cost per mile
- [ ] Dispatcher can override auto-assignments
- [ ] Assignment confirmation sent to carrier via carrier API

## Depends On
- #5 AUTH-001
- **#3 TRACK-003** ← _blocked until Carrier API backend is live_

## Blocks
- #12 DISP-008
- #13 DISP-009" \
  "dispatch,enhancement,sprint-3" "$MS3"

create_issue \
  "DISP-008: Load Tender Automation" \
  "## Overview
Automate load tender submission so approved loads are automatically tendered to the selected carrier via the carrier API without manual dispatcher action.

## Acceptance Criteria
- [ ] Auto-tender triggers when load is approved and carrier is assigned
- [ ] Carrier acceptance/rejection handled and routed back to dispatcher
- [ ] Failure alerting for tender timeouts

## Depends On
- #11 DISP-007

## Blocks
_None_" \
  "dispatch,enhancement,sprint-3" "$MS3"

create_issue \
  "DISP-009: Carrier Capacity Planning Dashboard" \
  "## Overview
Add a capacity planning view showing forecasted load volume vs. carrier capacity for the next 30 days, flagging potential capacity shortfalls.

## Acceptance Criteria
- [ ] Chart shows load forecast vs. capacity by carrier over 30-day window
- [ ] Shortfall periods highlighted in red
- [ ] Export to CSV

## Depends On
- #11 DISP-007
- #3 TRACK-003

## Blocks
_None_" \
  "dispatch,enhancement,sprint-3" "$MS3"

create_issue \
  "ORD-001: Order Service Integration" \
  "## Overview
Integrate LogiTrack with the order management service so shipments are automatically created when orders are confirmed, and order status is updated as shipments progress.

## Acceptance Criteria
- [ ] Order webhook receiver processes new-order events
- [ ] Shipment auto-created from order data with correct carrier assignment
- [ ] Order status updated (Shipped, In Transit, Delivered) via callback

## Depends On
- **#3 TRACK-003** ← _blocked until Carrier API backend is live_
- #5 AUTH-001

## Blocks
- #15 ORD-002
- #17 ACC-012
- #19 NOTIF-001
- #20 REV-001" \
  "orders,enhancement,sprint-3" "$MS3"

create_issue \
  "ORD-002: Order Confirmation Notifications" \
  "## Overview
Send automated order confirmation messages (email + in-app) when a shipment is created from an order event.

## Acceptance Criteria
- [ ] Email template for order confirmation
- [ ] In-app notification displayed in header
- [ ] Notification links to shipment tracking page

## Depends On
- #14 ORD-001

## Blocks
_None_" \
  "notifications,orders,enhancement,sprint-3" "$MS3"

create_issue \
  "SEARCH-001: Full-Text Shipment Search" \
  "## Overview
Upgrade the shipment search bar to support full-text search across tracking ID, destination, carrier, and status, with results ranking by relevance.

## Acceptance Criteria
- [ ] Search supports partial match on all shipment fields
- [ ] Results ranked by match relevance
- [ ] Search query reflected in URL param for shareability
- [ ] XSS-safe: search input is sanitized before rendering

## Depends On
- #4 ROUTE-001

## Blocks
- #23 PERF-001" \
  "tracking,enhancement,sprint-3" "$MS3"

echo ""
echo "Creating Sprint 4 issues…"

create_issue \
  "ACC-012: Order History & Account Timeline" \
  "## Overview
Build a complete order history view in the customer account section, showing all past shipments with status, carrier, and delivery date.

## Acceptance Criteria
- [ ] Timeline view of all orders, sorted by date descending
- [ ] Filter by status, carrier, and date range
- [ ] Export to CSV

## Depends On
- #14 ORD-001
- #5 AUTH-001

## Blocks
- #18 OPS-009" \
  "accounts,orders,enhancement,sprint-4" "$MS4"

create_issue \
  "OPS-009: Return Shipment Processing" \
  "## Overview
Build the return shipment workflow so customers can initiate return pickups and track return status through LogiTrack.

## Acceptance Criteria
- [ ] Return request form with pickup scheduling
- [ ] Return shipment auto-tendered to original carrier
- [ ] Return status tracked in account timeline

## Depends On
- #14 ORD-001
- #17 ACC-012

## Blocks
_None_" \
  "orders,enhancement,sprint-4" "$MS4"

create_issue \
  "NOTIF-001: Delivery Status Push Notifications" \
  "## Overview
Implement real-time push notifications for delivery status changes: out for delivery, delivered, exception, and estimated delay.

## Acceptance Criteria
- [ ] Web push notifications (browser) for subscribed users
- [ ] Email notifications for all status changes
- [ ] User can configure notification preferences per shipment

## Depends On
- #14 ORD-001

## Blocks
_None_" \
  "notifications,enhancement,sprint-4" "$MS4"

create_issue \
  "REV-001: Carrier Performance Reviews" \
  "## Overview
Allow dispatchers to submit post-delivery carrier performance reviews (rating, comments, incident flags) that feed into the carrier performance table.

## Acceptance Criteria
- [ ] Review form: 1–5 star rating, comments, incident type
- [ ] Reviews aggregated in carrier performance table
- [ ] Carriers with avg rating < 3 flagged for review

## Depends On
- #5 AUTH-001
- #14 ORD-001

## Blocks
_None_" \
  "carrier,enhancement,sprint-4" "$MS4"

echo ""
echo "Creating Sprint 5 issues…"

create_issue \
  "SUP-001: Dispatcher Help Desk Integration" \
  "## Overview
Integrate a help desk ticketing system so dispatchers can raise support tickets from within LogiTrack for carrier disputes, shipment exceptions, and billing issues.

## Acceptance Criteria
- [ ] 'Report Issue' button on shipment cards opens ticket form
- [ ] Tickets submitted to help desk API
- [ ] Ticket status visible in-app

## Depends On
_None_

## Blocks
_None_" \
  "support,enhancement,sprint-5" "$MS5"

create_issue \
  "SUP-002: Automated Exception Escalation" \
  "## Overview
Auto-escalate shipment exceptions (missed delivery, carrier no-show, lost shipment) to the dispatcher's help desk queue with pre-populated ticket data.

## Acceptance Criteria
- [ ] Exception events trigger automatic ticket creation
- [ ] Ticket includes shipment ID, carrier, exception type, and SLA window
- [ ] Dispatcher notified via in-app and email

## Depends On
- #5 AUTH-001
- #19 NOTIF-001

## Blocks
_None_" \
  "support,notifications,enhancement,sprint-5" "$MS5"

create_issue \
  "PERF-001: Dashboard Load Performance Optimization" \
  "## Overview
Profile and optimize dashboard load time, targeting < 2s first contentful paint on a standard corporate network connection.

## Acceptance Criteria
- [ ] Lighthouse performance score ≥ 90
- [ ] Lazy loading for off-screen shipment cards
- [ ] API calls de-duplicated and cached for 60 seconds

## Depends On
- #4 ROUTE-001
- #16 SEARCH-001

## Blocks
_None_" \
  "platform,enhancement,sprint-5" "$MS5"

create_issue \
  "A11Y-001: Accessibility Audit and Remediation" \
  "## Overview
Conduct a full WCAG 2.1 AA accessibility audit of the LogiTrack portal and remediate all critical and major findings.

## Acceptance Criteria
- [ ] axe DevTools audit passes with zero critical violations
- [ ] All interactive elements have ARIA labels
- [ ] Keyboard navigation works across all pages
- [ ] Color contrast meets WCAG AA standards

## Depends On
_None_

## Blocks
_None_" \
  "platform,enhancement,sprint-5" "$MS5"

echo ""
echo "✅ All 24 issues created for $REPO"
echo ""
echo "Issue map for reference:"
echo "  Sprint 1: #1 TRACK-001, #2 TRACK-002, #3 TRACK-003 (⚠️ blocks #9,#11,#14), #4 ROUTE-001"
echo "  Sprint 2: #5 AUTH-001, #6 AUTH-002, #7 AUTH-003, #8 AUTH-004, #9 CARR-005, #10 ACC-006"
echo "  Sprint 3: #11 DISP-007, #12 DISP-008, #13 DISP-009, #14 ORD-001, #15 ORD-002, #16 SEARCH-001"
echo "  Sprint 4: #17 ACC-012, #18 OPS-009, #19 NOTIF-001, #20 REV-001"
echo "  Sprint 5: #21 SUP-001, #22 SUP-002, #23 PERF-001, #24 A11Y-001"
echo ""
echo "Dependency cascade: if #3 TRACK-003 slips → blocks #9, #11, #14 → cascades to #12,#13,#15,#17,#18,#19,#20"
