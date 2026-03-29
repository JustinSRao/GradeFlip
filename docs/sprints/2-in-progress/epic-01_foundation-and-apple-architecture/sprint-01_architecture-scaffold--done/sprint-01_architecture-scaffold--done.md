---
sprint: 1
title: "Product architecture, data model, and repository scaffolding"
type: fullstack
epic: 1
status: done
created: 2026-03-26T16:02:31Z
started: 2026-03-26T16:20:10Z
completed: 2026-03-26
hours: null
workflow_version: "3.1.0"


---

# Sprint 1: Product architecture, data model, and repository scaffolding

## Overview

| Field | Value |
|-------|-------|
| Sprint | 1 |
| Title | Product architecture, data model, and repository scaffolding |
| Type | fullstack |
| Epic | 1 |
| Status | Done |
| Created | 2026-03-26 |
| Started | 2026-03-26 |
| Completed | 2026-03-26 |

## Goal

Define the core GradeFlip architecture, platform strategy, data boundaries, and repository structure so implementation can start without revisiting foundational decisions.

## Background

GradeFlip combines offline content storage, Apple-platform adaptation, subscription-backed online features, and multi-provider AI usage. Those concerns interact tightly. If the data model, module boundaries, or monetization boundaries are vague, later work will become expensive to unwind.

## Requirements

### Functional Requirements

- [x] Choose the primary app architecture for shared iPhone, iPad, and Mac development
- [x] Define the core domain model for decks, flashcards, notes, images, themes, users, subscriptions, and AI usage
- [x] Define which data is local-only, which data is cloud-backed, and which data must sync between the two modes
- [x] Define the repository structure and major modules for app, domain, persistence, sync, billing, and AI integrations
- [x] Recommend the online backend stack for auth, relational data, storage, and server-side functions
- [x] Define the backlog execution order and dependencies for the first 15 sprints

### Non-Functional Requirements

- [x] The architecture must support offline-first behavior for the paid core app
- [x] The architecture must allow iPhone, iPad, and Mac layouts to diverge where needed without splitting the codebase
- [x] The online layer must support future scale for messaging, social graphs, and token ledgers
- [x] The AI layer must be provider-agnostic and support cost tracking per request
- [x] The project plan must treat Sprint 15 as release-ready, not just prototype-complete
- [x] The backlog must require app scaffolding to progress alongside module work
- [x] The architecture must define a realistic Windows-authoring and macOS-validation workflow
- [x] The architecture must remain realistic for App Store review, privacy disclosures, and StoreKit usage

## Dependencies

- **Sprints**: None
- **External**: None

## Scope

### In Scope

- Apple-platform architecture decisions
- Domain model boundaries
- Storage and sync boundaries
- Backend recommendation
- Repository/module scaffolding plan
- App-shell scaffolding expectations for future sprints
- Implementation sequencing for the backlog

### Out of Scope

- Production UI implementation
- Persistence implementation details beyond the contract level
- Provider-specific AI integrations
- Final subscription or token pricing amounts

## Technical Approach

Use a shared native SwiftUI codebase with platform-adaptive presentation layers for iPhone, iPad, and macOS. Keep the paid core app offline-first, using local deck files for user content and optional SwiftData indexes for query convenience where it helps the UI. Use `Supabase + PostgreSQL` as the current backend recommendation because the product needs relational integrity for users, friendships, messages, likes, streaks, subscriptions, token balances, and shared decks, but keep that decision revisitable until the online implementation sprint begins.

Organize the repo around a shared domain layer, local persistence layer, online services layer, StoreKit/billing layer, and presentation features. Make deck IDs and flashcard IDs stable so later deck renames, image alignment, sharing, and AI context selection do not depend on copied display names. Require each subsequent sprint to scaffold the app-facing integration needed to exercise its work rather than postponing app assembly until the end.

## Tasks

### Phase 1: Planning

- [x] Consolidate the current product brief into a single architecture decision summary
- [x] Define the platform strategy for iPhone, iPad, and Mac
- [x] Define the split between offline core, subscription online features, and AI token usage
- [x] Define the Windows authoring and macOS validation operating model

### Phase 2: Implementation

- [x] Draft the domain model for content, users, social graph, billing, and AI usage
- [x] Draft the repository/module structure and ownership boundaries
- [x] Draft the local-versus-cloud data boundary contract
- [x] Scaffold the initial Apple app shell directories for future integration

### Phase 3: Validation

- [x] Validate the architecture against every requested product capability
- [x] Validate that the proposed backend supports social, billing, and AI metering needs
- [x] Validate that the sprint plan leads to a release-ready app by Sprint 15

### Phase 4: Documentation

- [x] Document the architecture decisions and sprint ordering for follow-on work
- [x] Document environment constraints for Windows development and Apple-platform testing

## Acceptance Criteria

- [x] A documented Apple-platform architecture exists for GradeFlip
- [x] The core domain model and service boundaries are defined
- [x] The online backend recommendation is justified and recorded
- [x] The repo/module plan is clear enough for Sprint 2 and Sprint 3 to begin
- [x] The backlog now assumes progressive app scaffolding and release readiness
- [x] Sprint 2 can start without re-opening foundational product questions

## Notes

Created: 2026-03-26

Sprint 1 deliverables:

- `docs/architecture/system-architecture.md`
- `docs/architecture/domain-model.md`
- `docs/architecture/backlog-sequence.md`
- `docs/architecture/development-and-testing-environments.md`
- `Package.swift`
- `apps/GradeFlipApple/README.md`
- `apps/GradeFlipApple/App/GradeFlipAppleApp.swift`
- `apps/GradeFlipApple/App/GradeFlipRootView.swift`
- `apps/GradeFlipApple/Features/README.md`
- `apps/GradeFlipApple/Resources/README.md`
- `packages/GradeFlipDomain/README.md`
- `packages/GradeFlipStorage/README.md`
- `packages/GradeFlipBilling/README.md`
- `packages/GradeFlipOnline/README.md`
- `packages/GradeFlipAI/README.md`
- `packages/GradeFlipDomain/Sources/GradeFlipDomain/Identifiers.swift`
- `packages/GradeFlipDomain/Sources/GradeFlipDomain/Models.swift`
- `packages/GradeFlipStorage/Sources/GradeFlipStorage/LocalDeckLayout.swift`
- `packages/GradeFlipBilling/Sources/GradeFlipBilling/Capabilities.swift`
- `packages/GradeFlipOnline/Sources/GradeFlipOnline/SocialModels.swift`
- `packages/GradeFlipAI/Sources/GradeFlipAI/AIContracts.swift`
- `packages/GradeFlipDomain/Tests/GradeFlipDomainTests/IdentifierTests.swift`
- `packages/GradeFlipBilling/Tests/GradeFlipBillingTests/CapabilityTests.swift`

Validation note:

- Repaired the Windows Swift toolchain by upgrading to Swift `6.3.0`.
- Fixed domain identifier `Codable` conformance so the package models compile and serialize correctly.
- Converted the package tests to `XCTest` and verified `swift test` passes on Windows when run with the Visual Studio developer environment and the Swift Windows `XCTest` library paths configured.
- Apple app runtime testing still requires macOS, so Windows should be treated as a partial development environment rather than the full release-validation environment.
