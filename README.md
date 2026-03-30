# GradeFlip

GradeFlip is a native Apple study app for iPhone, iPad, and Mac. The core product is intended to ship as a $5 paid App Store app with offline deck creation, flashcards, per-card notepads, protected local JSON storage, and image attachments. An optional subscription-backed online layer adds study buddies, sharing, messaging, likes, cloud sync, and friend streaks. AI study assistance is available through purchasable study tokens.

## Product Shape

- Native SwiftUI app shared across iOS, iPadOS, and macOS with platform-adaptive layouts
- Offline-first core experience for the one-time paid purchase
- Local deck storage in JSON plus deck-scoped image folders
- Optional online layer backed by a relational backend
- Multi-provider AI assistant with deck-grounded mode and web-enabled mode

## Architecture Docs

- `docs/architecture/system-architecture.md`
- `docs/architecture/domain-model.md`
- `docs/architecture/backlog-sequence.md`
- `docs/architecture/development-and-testing-environments.md`
- `docs/architecture/launch-readiness-checklist.md`
- `docs/architecture/privacy-disclosures.md`
- `docs/architecture/app-store-listing.md`
- `docs/architecture/windows-preview-harness.md`

## Planned Module Layout

- `apps/GradeFlipApple/`
- `packages/GradeFlipDomain/`
- `packages/GradeFlipStorage/`
- `packages/GradeFlipBilling/`
- `packages/GradeFlipOnline/`
- `packages/GradeFlipAI/`

## Current Backlog

### Epic 1: Foundation and Apple architecture

- Sprint 1: Product architecture, data model, and repository scaffolding
- Sprint 2: SwiftData and JSON storage pipeline for decks, cards, notes, and images
- Sprint 3: StoreKit purchase model, app modes, and feature gating foundation

### Epic 2: Local study content and persistence

- Sprint 4: Deck, flashcard, and deck editing flows
- Sprint 5: Notepad system with lined paper styling and per-card notes
- Sprint 6: Image import, auto-rename, preview, and delete safeguards

### Epic 3: Adaptive study experience and polish

- Sprint 7: iPhone study UI with realistic flashcard flip interaction
- Sprint 8: iPad adaptive workspace and multi-pane study flows
- Sprint 9: Mac app layout, themes, dark mode, and accessibility polish

### Epic 4: Online sync and social study

- Sprint 10: Online accounts, auth, and cloud sync backend
- Sprint 11: Study buddies, messaging, deck sharing, requests, and likes
- Sprint 12: Subscription online features and friend study streaks

### Epic 5: AI tutor and token economy

- Sprint 13: Multi-provider AI abstraction with deck-grounded chat
- Sprint 14: Web-enabled AI chat, study tokens, gifting, and usage metering

### Epic 6: Launch, billing, and App Store readiness

- Sprint 15: End-to-end QA, analytics, privacy, and App Store launch assets

### Epic 7: Windows preview harness and cross-platform interaction testing

- Sprint 16: Windows desktop or web preview harness foundation for offline interaction testing
- Sprint 17: Preview harness parity for study, deck editing, and smoke-test flows

## Working the Backlog

Planning rule for every sprint:

- Each sprint must leave the repo in a more app-shaped state than before it started.
- Scaffolding is not deferred to the end. If a sprint introduces storage, billing, sync, AI, or UI behavior, it should also wire the relevant app-facing integration surface needed to exercise that behavior later.
- By the end of Sprint 15, the repository should be in a release-ready state for Apple-platform shipping rather than a collection of isolated modules.
- Epic 7 is optional follow-on tooling for Windows development convenience. It is not a redefinition of the Apple release path.

## Windows Development Note

- Windows is a valid development environment for planning, docs, backend work, and shared Swift package code.
- Native iPhone, iPad, and macOS app execution still requires macOS. Apple simulators do not run natively on Windows, so final app verification needs a Mac, a remote macOS machine, or macOS CI.
- Windows-side testing remains useful for repo workflows and shared logic, but it is not a substitute for Apple-platform runtime validation.

## Windows Preview Harness

You can launch the local preview harness from Windows with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-preview-web.ps1
```

Run the smoke test with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\preview-smoke.ps1
```

Run commands from the project root:

```powershell
cd "C:\Users\nitsu\.Application_Development\Codex Projects\GradeFlip"
```

Start the first sprint with:

```powershell
sprint-start 1
```

Check and advance the active sprint with:

```powershell
sprint-status 1
sprint-next 1
```

Finish a sprint with:

```powershell
sprint-postmortem 1
sprint-complete 1
```

Do not manually edit `docs/sprints/registry.json` or sprint state files by hand during normal workflow operation.
