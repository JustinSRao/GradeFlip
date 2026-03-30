---
sprint: 11
title: "Study buddies, messaging, deck sharing, requests, and likes"
type: fullstack
epic: 4
status: in-progress
created: 2026-03-26T16:02:33Z
started: 2026-03-29T17:14:15Z
completed: null
hours: null
workflow_version: "3.1.0"

---

# Sprint 11: Study buddies, messaging, deck sharing, requests, and likes

## Overview

| Field | Value |
|-------|-------|
| Sprint | 11 |
| Title | Study buddies, messaging, deck sharing, requests, and likes |
| Type | fullstack |
| Epic | 4 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Build the social graph and messaging layer that lets users become study buddies, exchange decks, request decks, and react to shared content.

## Background

The online value of GradeFlip depends on social usefulness, not just cloud backup. Users need a clear way to add study buddies, communicate inside the app, share or request decks, and show lightweight feedback through likes.

## Requirements

### Functional Requirements

- [ ] Users can send, receive, accept, and reject study buddy requests
- [ ] Study buddies are represented as a stable social relationship in the backend
- [ ] The app has a messaging tab that can display deck shares, deck requests, and social messages
- [ ] Users can share flashcard decks with study buddies
- [ ] Users can request flashcard decks from study buddies
- [ ] Users can like other users' decks
- [ ] The system records who sent, received, accepted, liked, or shared content
- [ ] Shared deck access respects ownership and permissions
- [ ] The app scaffold gains navigable social and messaging surfaces during the sprint

### Non-Functional Requirements

- [ ] Social actions must be permission-safe and not expose private decks accidentally
- [ ] Messaging events must be durable enough to support later gifts and system notifications
- [ ] The relationship model must support later streak and analytics work
- [ ] The UX must make deck request versus deck share intent obvious
- [ ] Social actions must be attributable for audit and abuse handling

## Dependencies

- **Sprints**: 10
- **External**: Notification strategy and moderation decisions may follow later

## Scope

### In Scope

- Friend request lifecycle
- Study buddy relationship model
- Messaging tab event model
- Deck sharing and deck request flows
- Deck likes

### Out of Scope

- Token gifting logic beyond the message model needed later
- Subscription streak tracking
- AI sharing features
- Rich real-time chat beyond the core event/thread model

## Technical Approach

Build a study-buddy relationship layer on top of the authenticated online backend. Model messaging as structured events or threads that can carry deck-share, deck-request, like, and later token-gift events. Separate deck ownership from shared access so users can request or view shared decks without losing source attribution.

## Tasks

### Phase 1: Planning

- [ ] Define the study buddy state machine and permissions
- [ ] Define the messaging-tab event types and payloads
- [ ] Define the deck-sharing and deck-request access rules

### Phase 2: Implementation

- [ ] Implement friend request and study buddy flows
- [ ] Implement messaging-tab storage and retrieval for social events
- [ ] Implement deck sharing, requests, and likes
- [ ] Integrate the social flows into the app shell

### Phase 3: Validation

- [ ] Validate that only authorized buddies can access shared deck content
- [ ] Validate that share, request, and like events appear correctly in the messaging experience
- [ ] Validate that the social relationship model supports later streak features

### Phase 4: Documentation

- [ ] Document the social event model for later token gifts and streak logic

## Acceptance Criteria

- [ ] Users can become study buddies through explicit request flows
- [ ] Users can share decks and request decks through the app
- [ ] Likes are tracked against shared deck content
- [ ] The messaging tab can display the core social event types
- [ ] Sprint 12 and Sprint 14 can build on the same social event model
- [ ] The social slice is reachable from the app without later assembly work

## Notes

Created: 2026-03-26
