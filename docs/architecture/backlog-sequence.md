# GradeFlip Backlog Sequence

## Delivery Strategy

The backlog is ordered to establish foundations before user-facing polish and monetized extensions.

## Sequence

### Epic 1: Foundation and Apple architecture

1. Sprint 1
   Define architecture, domain boundaries, and repo/module structure.
2. Sprint 2
   Implement the local storage contract.
3. Sprint 3
   Implement monetization and feature-gating foundations.

### Epic 2: Local study content and persistence

4. Sprint 4
   Build deck and flashcard CRUD.
5. Sprint 5
   Build per-card notepads and dictation.
6. Sprint 6
   Build image import and image handling.

### Epic 3: Adaptive study experience and polish

7. Sprint 7
   Build the phone-first study experience.
8. Sprint 8
   Build the iPad workspace.
9. Sprint 9
   Build the Mac layout and theme system.

### Epic 4: Online sync and social study

10. Sprint 10
    Build auth and online sync.
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
    Run end-to-end QA, analytics, privacy, and launch preparation.

## Dependency Highlights

- Sprint 2 depends on Sprint 1.
- Sprint 4, 5, and 6 depend on Sprint 2.
- Sprint 7, 8, and 9 depend on the local content sprints.
- Sprint 10 depends on foundational storage and gating decisions.
- Sprint 11 depends on Sprint 10.
- Sprint 12 depends on Sprint 3, 10, and 11.
- Sprint 14 depends on Sprint 11 and 13.
- Sprint 15 depends on the effective completion of all preceding delivery sprints.

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
