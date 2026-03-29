---
sprint: 3
title: "StoreKit purchase model, app modes, and feature gating foundation"
type: fullstack
epic: 1
status: done
created: 2026-03-26T16:02:31Z
started: 2026-03-29T16:30:56Z
completed: 2026-03-29
hours: null
workflow_version: "3.1.0"


---

# Sprint 3: StoreKit purchase model, app modes, and feature gating foundation

## Overview

| Field | Value |
|-------|-------|
| Sprint | 3 |
| Title | StoreKit purchase model, app modes, and feature gating foundation |
| Type | fullstack |
| Epic | 1 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Define and implement the product-access model for the paid app, optional online subscription, and AI token purchases so GradeFlip's feature boundaries are enforceable from the start and integrated into the app scaffold.

## Background

GradeFlip is not a simple free app. The core app is a one-time paid purchase, the online mode adds recurring monthly billing, and AI usage is gated by token purchases. If those access rules are bolted on later, the UI and backend will drift into inconsistent assumptions.

## Requirements

### Functional Requirements

- [ ] Define the paid core app entitlement and what is included with the one-time purchase
- [ ] Define the optional online subscription entitlement and which features it unlocks
- [ ] Define AI study tokens as separate purchasable units from the subscription
- [ ] Define how local mode works without an online account
- [ ] Define how online mode is presented when the user has a paid app purchase but no subscription
- [ ] Define how the client checks entitlements and hides or locks gated features
- [ ] Define placeholder product IDs and StoreKit configuration strategy for app, subscription, and tokens
- [ ] Scaffold app-facing billing and entitlement presentation flows as part of the sprint

### Non-Functional Requirements

- [ ] Feature gating must fail safely and not accidentally unlock paid features
- [ ] The user must be able to use the offline app without unnecessary account friction
- [ ] Subscription price values must remain configurable until business decisions are finalized
- [ ] Store configuration must support later sandbox/TestFlight testing
- [ ] Product messaging must be understandable inside the app

## Dependencies

- **Sprints**: 1
- **External**: Apple StoreKit product configuration, unresolved subscription pricing values

## Scope

### In Scope

- Product entitlement model
- App-mode definitions
- Feature gating rules
- StoreKit product planning and scaffolding
- AI token product boundary definition

### Out of Scope

- Final implementation of online subscription features
- Final implementation of AI metering logic
- Marketing page copy
- Final pricing decisions for the monthly plan

## Technical Approach

Model GradeFlip access in three layers: the paid core app entitlement, the recurring online subscription entitlement, and consumable AI token purchases. The client should query a single gating layer instead of scattering purchase checks through views. That gating layer should expose capabilities such as `canUseOfflineDecks`, `canUseOnlineSync`, `canUseStudyBuddies`, and `canSpendAITokens`.

Keep product identifiers and price presentation configurable. Plan for StoreKit 2 on device and a server-side entitlement record for online features where needed.

## Tasks

### Phase 1: Planning

- [ ] Define the capability matrix for paid core, subscription online, and token purchases
- [ ] Define account requirements for each app mode
- [ ] Define product identifiers and store surface assumptions

### Phase 2: Implementation

- [ ] Implement or scaffold the feature-gating layer
- [ ] Implement or scaffold StoreKit product configuration support
- [ ] Wire the app-mode model so later sprints can target the right capability checks
- [ ] Scaffold paywall, entitlement, and locked-feature presentation entry points in the app shell

### Phase 3: Validation

- [ ] Validate that every requested feature maps to the correct monetization tier
- [ ] Validate that offline usage remains available without subscription entitlements

### Phase 4: Documentation

- [ ] Document the product-access matrix for future UI, backend, and launch work

## Acceptance Criteria

- [ ] GradeFlip's purchase, subscription, and token models are clearly defined
- [ ] A capability-based gating model exists for the app
- [ ] Offline core features are separated cleanly from subscription-only online features
- [ ] Token purchases are defined separately from monthly billing
- [ ] The app scaffold exposes the capability model in a way later sprints can reuse directly
- [ ] Later sprints can implement gated features without re-litigating the business model

## Notes

Created: 2026-03-26
