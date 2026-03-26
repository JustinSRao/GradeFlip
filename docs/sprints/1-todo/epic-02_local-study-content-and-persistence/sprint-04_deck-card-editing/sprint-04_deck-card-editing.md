---
sprint: 4
title: "Deck, flashcard, and deck editing flows"
type: fullstack
epic: 2
status: planning
created: 2026-03-26T16:02:32Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 4: Deck, flashcard, and deck editing flows

## Overview

| Field | Value |
|-------|-------|
| Sprint | 4 |
| Title | Deck, flashcard, and deck editing flows |
| Type | fullstack |
| Epic | 2 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Deliver the core local CRUD flows for decks and flashcards, including editing existing content and safe delete confirmation.

## Background

The app is not useful until a user can create decks, add cards, edit them later, and manage deck organization confidently. You specifically asked for deck renames to apply cleanly across the deck and for delete actions to require verification before destructive changes happen.

## Requirements

### Functional Requirements

- [ ] Users can create, rename, and delete decks locally
- [ ] Users can create, edit, and delete flashcards inside a deck
- [ ] Users can edit existing flashcard front and back content without recreating the card
- [ ] Deck renames do not orphan flashcards because cards reference stable deck IDs
- [ ] Delete actions for decks and flashcards require explicit user confirmation
- [ ] Local deck and flashcard changes persist through the deck JSON pipeline
- [ ] The deck list can show card counts and basic metadata needed for browsing

### Non-Functional Requirements

- [ ] CRUD interactions must be responsive on device
- [ ] Delete confirmation UX must reduce accidental loss
- [ ] The implementation must preserve data integrity in the local file model
- [ ] The flow must remain adaptable to later iPhone, iPad, and Mac UI variants
- [ ] The content model must remain compatible with future sync and sharing

## Dependencies

- **Sprints**: 2, 3
- **External**: None

## Scope

### In Scope

- Deck CRUD
- Flashcard CRUD
- Rename flows
- Delete confirmation UX for decks and flashcards
- Local persistence wiring

### Out of Scope

- Per-card notes editing
- Image import
- Online sharing
- AI features

## Technical Approach

Build deck and flashcard management on top of the deck-scoped JSON persistence layer from Sprint 2. Use stable identifiers for decks and cards, and store display names separately so deck renames do not cascade through copied text fields. Route destructive actions through a single confirmation pattern shared across platforms.

## Tasks

### Phase 1: Planning

- [ ] Define the exact deck and card edit operations needed for MVP
- [ ] Define the confirmation behavior for deck and card deletion
- [ ] Define deck metadata needed in lists and study screens

### Phase 2: Implementation

- [ ] Implement deck create, rename, and delete flows
- [ ] Implement flashcard create, edit, and delete flows
- [ ] Wire CRUD flows into the local storage layer

### Phase 3: Validation

- [ ] Validate that deck renames do not break card associations
- [ ] Validate that delete confirmation always appears before destructive actions

### Phase 4: Documentation

- [ ] Document the CRUD behavior and data assumptions for later UI sprints

## Acceptance Criteria

- [ ] Users can create, edit, rename, and delete decks locally
- [ ] Users can create, edit, and delete flashcards locally
- [ ] Deck renames remain consistent across the deck's cards
- [ ] Delete confirmation exists for deck and flashcard removal
- [ ] The local CRUD layer is stable enough for notes and image attachments to build on top of it

## Notes

Created: 2026-03-26
