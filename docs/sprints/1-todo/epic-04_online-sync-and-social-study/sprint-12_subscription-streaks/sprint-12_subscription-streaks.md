---
sprint: 12
title: "Subscription online features and friend study streaks"
type: fullstack
epic: 4
status: planning
created: 2026-03-26T16:02:33Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 12: Subscription online features and friend study streaks

## Overview

| Field | Value |
|-------|-------|
| Sprint | 12 |
| Title | Subscription online features and friend study streaks |
| Type | fullstack |
| Epic | 4 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Implement the subscription-only online features layer, including recurring entitlement handling and friend study streak tracking.

## Background

The online mode is the monthly offering on top of the paid app. That means the app needs clear subscription-gated behavior, and one of the premium retention features you requested is study streaks that users can maintain with friends.

## Requirements

### Functional Requirements

- [ ] Recognize whether a user has an active online subscription entitlement
- [ ] Gate subscription-only online features behind that entitlement
- [ ] Track personal and friend-linked study streak activity based on defined study events
- [ ] Show current streak state and reset behavior clearly enough for the product UX
- [ ] Support configurable subscription pricing and packaging while business pricing is still undecided
- [ ] Support subscription lapse behavior without deleting owned offline content
- [ ] Ensure users without a subscription can still use the paid offline app normally

### Non-Functional Requirements

- [ ] Subscription checks must not degrade the offline-first app experience
- [ ] Streak logic must be deterministic and auditable
- [ ] Entitlement state must be resilient to temporary network issues where practical
- [ ] The design must avoid punishing users with data loss when subscriptions expire
- [ ] Product rules must remain configurable until pricing is finalized

## Dependencies

- **Sprints**: 3, 10, 11
- **External**: Final monthly pricing decision, App Store subscription configuration

## Scope

### In Scope

- Subscription entitlement handling
- Subscription-gated online feature checks
- Study streak event model and counters
- Friend streak visibility and reset rules

### Out of Scope

- AI token purchases
- Marketing experiments around pricing
- Complex streak gamification beyond the core requested behavior
- App Store launch assets

## Technical Approach

Reuse the capability-based gating model from Sprint 3 and connect it to actual online subscription entitlements. Define study streaks from explicit qualifying study events so the logic is deterministic. Store streak calculations or normalized streak events in the backend where cross-device and friend-linked tracking can be reconciled safely.

## Tasks

### Phase 1: Planning

- [ ] Define which features are subscription-only versus paid-core
- [ ] Define the streak event rules, reset rules, and friend-link behavior
- [ ] Define subscription lapse behavior and grace assumptions

### Phase 2: Implementation

- [ ] Implement subscription entitlement evaluation in the online layer
- [ ] Implement streak event recording and counters
- [ ] Implement user-facing streak surfaces for premium users

### Phase 3: Validation

- [ ] Validate that non-subscribers keep offline access
- [ ] Validate streak calculations across multiple study days and friend relationships
- [ ] Validate that subscription lapse behavior does not corrupt content access

### Phase 4: Documentation

- [ ] Document the subscription and streak rules for launch and analytics work

## Acceptance Criteria

- [ ] Online premium features are gated by subscription state
- [ ] Study streaks can be tracked for users and friends
- [ ] Subscription lapse does not break offline ownership
- [ ] Streak logic is deterministic enough for analytics and support
- [ ] The premium online tier is now meaningfully differentiated from the paid core app

## Notes

Created: 2026-03-26
