# GradeFlip Backlog Sequence

## Delivery Strategy

The backlog is ordered to establish foundations before user-facing polish and monetized extensions.

Two planning rules apply across the entire sequence:

1. Every sprint must advance the real app scaffold, not only the underlying modules or docs.
2. Sprint 15 is the endpoint for release readiness, so earlier sprints should avoid deferring essential integration, security, and validation work unnecessarily.

## Sequence

### Epic 1: Foundation and Apple architecture

1. Sprint 1
   Define architecture, domain boundaries, and repo/module structure.
2. Sprint 2
   Implement the local storage contract and app-facing persistence integration scaffold.
3. Sprint 3
   Implement monetization and feature-gating foundations plus StoreKit-facing app scaffolding.

### Epic 2: Local study content and persistence

4. Sprint 4
   Build deck and flashcard CRUD with app navigation and editing surfaces.
5. Sprint 5
   Build per-card notepads and dictation with integrated note UI surfaces.
6. Sprint 6
   Build image import and image handling with app-level preview and removal flows.

### Epic 3: Adaptive study experience and polish

7. Sprint 7
   Build the phone-first study experience as a usable app slice.
8. Sprint 8
   Build the iPad workspace as a real platform-adaptive extension of the app shell.
9. Sprint 9
   Build the Mac layout and theme system with accessibility and desktop validation.

### Epic 4: Online sync and social study

10. Sprint 10
    Build auth and online sync with a revisitable backend decision finalized at implementation start.
11. Sprint 11
    Build study buddies, messaging, sharing, requests, and likes.
12. Sprint 12
    Build subscription-gated online features and streaks.

### Epic 5: AI tutor and token economy

13. Sprint 13
    Build provider abstraction and deck-grounded AI.
14. Sprint 14
    Build web-enabled AI, token metering, and gifting.

### Epic 6: Launch, billing, and App Store readiness

15. Sprint 15
    Run end-to-end QA, analytics, privacy, submission preparation, and release signoff.

### Epic 7: Windows preview harness and cross-platform interaction testing

16. Sprint 16
    Build a Windows-runnable preview harness for offline interaction testing.
17. Sprint 17
    Extend the harness for broader parity and smoke-test workflows.

## Dependency Highlights

- Sprint 2 depends on Sprint 1.
- Sprint 4, 5, and 6 depend on Sprint 2.
- Sprint 7, 8, and 9 depend on the local content sprints.
- Sprint 10 depends on foundational storage and gating decisions.
- Sprint 11 depends on Sprint 10.
- Sprint 12 depends on Sprint 3, 10, and 11.
- Sprint 14 depends on Sprint 11 and 13.
- Sprint 15 depends on the effective completion of all preceding delivery sprints.
- Sprint 16 depends on the offline product and adaptive study work already being in place.
- Sprint 17 depends on Sprint 16.

## Suggested Milestones

### Milestone A: Core offline MVP

Complete Sprints 1 through 7.

Result:

- architecture defined
- local storage in place
- paid-core gating in place
- deck CRUD in place
- notes in place
- image support in place
- usable iPhone study experience in place

### Milestone B: Full Apple-platform offline product

Complete Sprints 1 through 9.

Result:

- distinct iPhone, iPad, and Mac experiences
- theme system in place
- dark/light support in place

### Milestone C: Online social layer

Complete Sprints 10 through 12.

Result:

- online accounts
- sync
- buddies
- messaging
- sharing
- likes
- streaks

### Milestone D: AI commerce layer

Complete Sprints 13 and 14.

Result:

- multi-provider deck-grounded AI
- web-enabled AI
- study tokens
- gifting
- deterministic usage metering

### Milestone E: Windows interaction harness

Complete Sprints 16 and 17.

Result:

- Windows-runnable interaction harness for the offline slice
- smoke-testable preview path without Apple simulators
- clearer separation between Windows preview validation and Apple runtime QA
