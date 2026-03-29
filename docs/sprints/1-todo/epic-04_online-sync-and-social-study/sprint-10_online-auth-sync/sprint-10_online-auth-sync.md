---
sprint: 10
title: "Online accounts, auth, and cloud sync backend"
type: fullstack
epic: 4
status: planning
created: 2026-03-26T16:02:33Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 10: Online accounts, auth, and cloud sync backend

## Overview

| Field | Value |
|-------|-------|
| Sprint | 10 |
| Title | Online accounts, auth, and cloud sync backend |
| Type | fullstack |
| Epic | 4 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Build the account and cloud foundation for GradeFlip's subscription-backed online mode, including auth, relational data storage, and deck synchronization.

## Background

The offline app is the base product, but the online subscription needs a robust backend rather than an afterthought. Users need accounts, cloud persistence, and sync behavior that respects the local JSON model without forcing online access on offline-only users.

## Requirements

### Functional Requirements

- [ ] Support account creation, sign-in, and sign-out for the online mode
- [ ] Use a relational backend suitable for users, decks, notes, images, friendships, messages, streaks, subscriptions, and token ledgers
- [ ] Sync decks, flashcards, notes, and image metadata between local storage and the online backend
- [ ] Keep offline-only usage available without forcing account creation
- [ ] Support cloud storage for online deck data and related assets
- [ ] Define conflict-handling rules for edits made across devices
- [ ] Define server-side access rules so users only access their own protected content by default
- [ ] Finalize whether `Supabase + PostgreSQL` remains the backend choice before implementation begins
- [ ] Scaffold app-facing auth and sync entry points during the sprint

### Non-Functional Requirements

- [ ] Online sync must not compromise the offline-first core experience
- [ ] The backend model must scale to social and billing features planned in later sprints
- [ ] The sync design must avoid obvious duplication or corruption paths
- [ ] Auth and data access rules must support secure multi-user behavior
- [ ] The architecture must remain compatible with App Store privacy requirements

## Dependencies

- **Sprints**: 1, 2, 3, 4, 5, 6
- **External**: Current plan assumes `Supabase + PostgreSQL`, but backend selection remains revisitable until Sprint 10 starts

## Scope

### In Scope

- Online account model
- Authentication flows
- Core relational schema for synced content
- Local-to-cloud sync strategy
- Protected access rules

### Out of Scope

- Friend requests and messaging
- Deck sharing UX
- Subscription streak logic
- AI chat features

## Technical Approach

Unless a documented decision changes beforehand, use `Supabase + PostgreSQL`, authentication, storage, and row-level security as the online platform. Map local deck/card/note/image IDs into server-side records so the same stable identifiers can support sync, sharing, and AI deck selection later. Keep offline JSON storage as the local source that sync jobs reconcile with server records instead of replacing the offline model outright.

## Tasks

### Phase 1: Planning

- [ ] Define the relational schema for users and synced study content
- [ ] Define sync directions, triggers, and conflict rules
- [ ] Define account and session flows for the client
- [ ] Confirm and document the final backend choice at sprint start

### Phase 2: Implementation

- [ ] Implement auth scaffolding and protected user sessions
- [ ] Implement cloud schema and storage structure for synced content
- [ ] Implement the first-pass local-to-cloud sync pipeline
- [ ] Integrate account and sync surfaces into the app shell

### Phase 3: Validation

- [ ] Validate that offline-only usage still works without account login
- [ ] Validate that synced deck data remains consistent with local identifiers
- [ ] Validate that protected access rules prevent cross-user leakage

### Phase 4: Documentation

- [ ] Document the online data model and sync assumptions for later social work

## Acceptance Criteria

- [ ] Users can create accounts and authenticate for online mode
- [ ] GradeFlip has a relational backend suitable for the planned social and billing features
- [ ] Core study content can be represented in the online data model
- [ ] The sync design respects the offline-first app model
- [ ] Sprint 11 can build social features without redefining the backend foundation
- [ ] The app has a usable authenticated online entry path after this sprint

## Notes

Created: 2026-03-26
