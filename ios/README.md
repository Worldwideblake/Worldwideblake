# Job Tracker — native iOS app (SwiftUI)

A native SwiftUI version of the job tracker, sharing the same seed data
(`JobTracker/Resources/seed.json`) as the web app in `/job-tracker`.

> **Fastest way to get the tracker on your iPhone today:** you don't need this app.
> Enable GitHub Pages for this repo, open the web tracker in Safari, tap **Share →
> Add to Home Screen** — it installs as a full-screen app with its own icon, works
> offline, and needs no App Store review. This folder is for when you want a true
> native app.

## What's here

| File | Purpose |
|---|---|
| `JobTracker/JobTrackerApp.swift` | App entry point |
| `JobTracker/Models.swift` | `Job` model + `JobStatus` (colors, SF Symbols) |
| `JobTracker/JobStore.swift` | Persistence (Documents/jobs.json), seed merging, CSV export |
| `JobTracker/ContentView.swift` | Job list, stat tiles, search, filters, swipe-to-apply |
| `JobTracker/JobDetailView.swift` | Job detail: status, applied date, notes, links |
| `JobTracker/AddJobView.swift` | Add-a-job sheet |
| `JobTracker/Resources/seed.json` | The 54 verified Texas jobs (auto-generated from the web app) |

Features: stat tiles that filter by status, search, city/category/status filters,
swipe right to mark **Applied** (auto-stamps the date), swipe left to remove,
CSV export via the share sheet, links out to each posting and careers page.
All data stays on-device — no accounts, no network calls.

## Building it (requires a Mac)

This was written on Linux, where Xcode can't run, so **it has not been compiled yet** —
expect possibly a minor fix-up when you first build. Steps:

1. On a Mac with Xcode 15+: **File → New → Project → iOS App**, name it `JobTracker`,
   interface SwiftUI, language Swift, minimum deployment **iOS 17**.
2. Delete the template `ContentView.swift`, then drag the contents of `JobTracker/`
   (all `.swift` files and `Resources/seed.json`) into the project navigator.
   Make sure `seed.json` is added to the app target (checked under Target Membership).
3. Run on the simulator or your iPhone (free with any Apple ID via
   Signing & Capabilities → your personal team; apps signed this way expire after
   7 days and need re-installing).

## Shipping to the App Store (Apple's standards)

- **Apple Developer Program** — $99/year, required for TestFlight and the App Store.
- **App icon** — reuse `job-tracker/icon-512.png` (add a 1024×1024 version in the
  asset catalog).
- **Privacy** — this app stores everything locally and makes no network requests,
  so the App Privacy label is simply "Data Not Collected," and no privacy policy
  complications apply.
- **Review guideline 4.2 (minimum functionality)** — Apple sometimes rejects simple
  utility apps. Strengthen the case by adding a home-screen widget (upcoming
  deadlines / applied count) and local notifications for follow-up reminders —
  both are natural next features for this codebase.
- Submit via Xcode → Product → Archive → Distribute.
