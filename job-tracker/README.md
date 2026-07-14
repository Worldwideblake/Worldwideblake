# Blake's Job Tracker

A self-contained job application tracker for finding and tracking data / cloud / AI / consulting
roles in **Houston, Austin, and Dallas, TX** — targeting Fortune 500 companies, PwC and other
consulting firms, and Texas startups.

## Get it on your iPhone (recommended)

1. Enable GitHub Pages for this repo: **Settings → Pages → Source: Deploy from a branch →
   `main` / root → Save**.
2. On your iPhone, open `https://worldwideblake.github.io/Worldwideblake/job-tracker/` in Safari.
3. Tap **Share → Add to Home Screen**.

It installs as a full-screen app with its own icon, works offline, and your data stays on the
phone. (A native SwiftUI version for the App Store route lives in [`/ios`](../ios) — it needs a
Mac with Xcode to build.)

You can also just download `index.html` and double-click it on any computer — no install needed.

## Features

- **Pre-seeded pipeline** — companies and roles verified against the company's own careers site.
  Every row has an **Apply ↗** link to the posting and a **careers ↗** link to the company's
  job-search page pre-filtered where possible.
- **Status tracking** — Not Applied → Saved → Applied → Interviewing → Offer / Rejected / Closed.
  Setting a row to *Applied* auto-stamps today's date.
- **Stat tiles** — tap a tile (Applied, Interviewing, …) to filter to those rows.
- **Search & filters** — by city, category (Fortune 500 / Consulting / Startup), and status.
- **Add your own jobs**, edit notes and dates inline.
- **Export CSV** for spreadsheets; **Backup/Restore JSON** to move your data between devices
  (data lives in the browser's localStorage).
- Installable PWA with offline support, light & dark mode, phone-optimized card layout.

## Keeping it fresh

The seed list is **refreshed automatically twice a week** (Monday and Thursday) by a scheduled
Claude Code session that re-verifies existing links, drops closed postings, and adds newly
opened roles, then pushes the update here. Your statuses, notes, and deletions are never
overwritten — new seed rows merge in alongside them (pull the latest `index.html`, or just
reload the GitHub Pages site).

Postings still move fast: before applying, click through and confirm the role is open on the
company's site. When a posting closes, set its status to **Closed** and check the careers link
for its replacement.

## About the target profile

Seeded for **Blake Mills** — AI Data Engineer intern (UTSA, class of May 2027), AWS Certified AI
Practitioner, experience with Dagster, GCP, Pulumi, AWS, and Python/SQL. Blake's current
internship ends **December 31, 2026**, so the list prioritizes roles that can start around
January 2027 or sooner — internships, co-ops, and apprenticeships with near-term starts, plus
early-career/new-grad roles in data engineering, data analytics, cloud, AI/ML, and technology
consulting.
