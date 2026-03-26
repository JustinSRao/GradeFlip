# GradeFlip System Architecture

## Purpose

This document defines the initial system architecture for GradeFlip. It is the canonical output of Sprint 1 and exists so later implementation sprints can build against a stable product and technical structure.

## Product Model

GradeFlip has three monetization and capability layers:

1. Paid core app
   The one-time $5 App Store purchase unlocks the offline-first study app.
2. Online subscription
   A recurring subscription unlocks cloud sync, study buddies, messaging, deck sharing, likes, and friend streaks.
3. AI study tokens
   Consumable token purchases unlock AI usage. AI availability is not bundled into the monthly subscription by default.

These layers must be modeled separately. The app should not assume that an active subscription implies free AI usage, and it should not assume that AI token ownership implies access to subscription-only social features.

## Platform Strategy

GradeFlip should use a shared native Apple codebase:

- `SwiftUI` for presentation
- `StoreKit 2` for paid app, subscription, and consumable token products
- Apple platform adaptation for:
  - `iPhone`
  - `iPad`
  - `macOS`

The app should share domain, persistence, sync, and AI orchestration logic, but it should not force one identical UI across all three platforms. The phone, iPad, and Mac experiences should intentionally diverge in layout and navigation.

## Architectural Priorities

- Offline-first for the paid core app
- Stable identifiers for decks, cards, notes, images, users, and transactions
- Clear separation between local-only and cloud-backed data
- Capability-based gating for monetization
- Provider-agnostic AI orchestration
- App Store-realistic privacy and billing behavior

## Recommended Tech Stack

### Client

- SwiftUI
- Swift packages for modular shared code
- SwiftData only where it helps local indexing, caching, or UI queries
- Local JSON files as the canonical deck and note storage format
- FileManager-backed deck/image storage

### Online Backend

Use `Supabase + PostgreSQL` instead of MongoDB.

Reasoning:

- GradeFlip's online model is relational:
  - users
  - buddy relationships
  - friend requests
  - likes
  - message events
  - streaks
  - subscriptions
  - token balances
  - gift transactions
  - shared deck permissions
- PostgreSQL gives stronger integrity and query flexibility than MongoDB for this shape.
- Supabase covers:
  - auth
  - Postgres database
  - row-level security
  - storage buckets
  - edge/server functions

MongoDB would make some document storage easy, but it is a worse fit for the social, billing, and ledger-heavy part of the product.

## Local Data Boundary

Local mode is the default operating model for the paid core app.

Local data includes:

- decks
- flashcards
- per-card notes
- deck-scoped metadata
- image files
- theme preferences
- local study state

The app must remain useful with no account and no network connection.

## Cloud Data Boundary

Cloud-backed data exists only for the online mode and selected shared services.

Cloud data includes:

- user account records
- synced deck metadata and content
- social graph
- shared deck permissions
- message events
- likes
- streak activity
- subscription entitlements
- token ledger
- AI usage ledger

## AI Boundary

GradeFlip supports two AI modes:

1. Deck-grounded mode
   Answers are constrained to selected GradeFlip decks.
2. Web-enabled mode
   Answers may use external web retrieval in addition to app context.

The AI orchestration layer must be provider-agnostic and support:

- OpenAI
- Anthropic
- Google Gemini
- xAI Grok
- DeepSeek

Usage pricing must be estimated through deterministic computation, not by making another model call.

## Repository Structure

The repo should grow into this shape:

```text
apps/
  GradeFlipApple/
    README.md
packages/
  GradeFlipDomain/
    README.md
  GradeFlipStorage/
    README.md
  GradeFlipBilling/
    README.md
  GradeFlipOnline/
    README.md
  GradeFlipAI/
    README.md
docs/
  architecture/
    system-architecture.md
    domain-model.md
    backlog-sequence.md
```

## Module Responsibilities

### `GradeFlipDomain`

Owns shared core models and use cases:

- decks
- flashcards
- notes
- images
- users
- social relationships
- subscriptions
- token transactions
- AI sessions

### `GradeFlipStorage`

Owns local persistence:

- deck JSON codecs
- note JSON codecs
- file storage helpers
- image asset storage
- migration/versioning of local files

### `GradeFlipBilling`

Owns monetization rules:

- app purchase entitlement
- subscription entitlement
- AI token product metadata
- capability gating

### `GradeFlipOnline`

Owns backend integration:

- auth
- sync
- sharing
- messaging
- likes
- streaks
- cloud storage references

### `GradeFlipAI`

Owns AI orchestration:

- provider abstraction
- deck context packaging
- web-enabled mode orchestration
- usage accounting inputs

### `GradeFlipApple`

Owns platform-specific UI composition and adaptation for:

- iPhone
- iPad
- Mac

## Capability Model

Capabilities should be evaluated explicitly instead of scattering billing checks through UI code.

Example capabilities:

- `canUseOfflineDecks`
- `canSyncOnline`
- `canUseStudyBuddies`
- `canUseMessaging`
- `canTrackFriendStreaks`
- `canSpendAITokens`
- `canUseWebEnabledAI`

## Assumptions Recorded in Sprint 1

- The base app is a paid app, not free-to-download.
- The monthly subscription price is still undecided.
- AI token pack pricing is still undecided.
- The same Apple app bundle should support offline core, online subscription, and AI tokens.
- Local deck storage remains canonical on device even after sync support is added.

## Deferred Decisions

These remain intentionally unresolved after Sprint 1:

- final subscription price
- final token pack pricing
- exact App Store product identifiers
- exact sync conflict-resolution policy details
- exact AI provider rollout order
