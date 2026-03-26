---
sprint: 1
title: "Product architecture, data model, and repository scaffolding"
type: fullstack
epic: 1
status: in-progress
created: 2026-03-26T16:02:31Z
started: 2026-03-26T16:20:10Z
completed: null
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
| Status | In Progress |
| Created | 2026-03-26 |
| Started | 2026-03-26 |
| Completed | - |

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
- Implementation sequencing for the backlog

### Out of Scope

- Production UI implementation
- Persistence implementation details beyond the contract level
- Provider-specific AI integrations
- Final subscription or token pricing amounts

## Technical Approach

Use a shared native SwiftUI codebase with platform-adaptive presentation layers for iPhone, iPad, and macOS. Keep the paid core app offline-first, using local deck files for user content and optional SwiftData indexes for query convenience where it helps the UI. Use Supabase with PostgreSQL for the online layer because the product needs relational integrity for users, friendships, messages, likes, streaks, subscriptions, token balances, and shared decks.

Organize the repo around a shared domain layer, local persistence layer, online services layer, StoreKit/billing layer, and presentation features. Make deck IDs and flashcard IDs stable so later deck renames, image alignment, sharing, and AI context selection do not depend on copied display names.

## Tasks

### Phase 1: Planning

- [x] Consolidate the current product brief into a single architecture decision summary
- [x] Define the platform strategy for iPhone, iPad, and Mac
- [x] Define the split between offline core, subscription online features, and AI token usage

### Phase 2: Implementation

- [x] Draft the domain model for content, users, social graph, billing, and AI usage
- [x] Draft the repository/module structure and ownership boundaries
- [x] Draft the local-versus-cloud data boundary contract

### Phase 3: Validation

- [x] Validate the architecture against every requested product capability
- [x] Validate that the proposed backend supports social, billing, and AI metering needs

### Phase 4: Documentation

- [x] Document the architecture decisions and sprint ordering for follow-on work

## Acceptance Criteria

- [x] A documented Apple-platform architecture exists for GradeFlip
- [x] The core domain model and service boundaries are defined
- [x] The online backend recommendation is justified and recorded
- [x] The repo/module plan is clear enough for Sprint 2 and Sprint 3 to begin
- [x] Sprint 2 can start without re-opening foundational product questions

## Notes

Created: 2026-03-26

Sprint 1 deliverables:

- `docs/architecture/system-architecture.md`
- `docs/architecture/domain-model.md`
- `docs/architecture/backlog-sequence.md`
- `Package.swift`
- `apps/GradeFlipApple/README.md`
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

- Attempted to run the Swift package tests after installing the Windows Swift toolchain.
- The installed toolchain is missing `swift-driver.exe`, causing Swift CLI processes to fail with Windows exit code `0xC0000135`.
- Architectural validation was completed, but automated Swift test execution could not be completed in this environment.
