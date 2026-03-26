---
sprint: 2
title: "SwiftData and JSON storage pipeline for decks, cards, notes, and images"
type: fullstack
epic: 1
status: planning
created: 2026-03-26T16:02:31Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 2: SwiftData and JSON storage pipeline for decks, cards, notes, and images

## Overview

| Field | Value |
|-------|-------|
| Sprint | 2 |
| Title | SwiftData and JSON storage pipeline for decks, cards, notes, and images |
| Type | fullstack |
| Epic | 1 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Implement the local storage contract for GradeFlip so decks, flashcards, notes, and images can be stored predictably on device and later synced safely.

## Background

The core GradeFlip app depends on local persistence. Your requirements are specific: each deck should use JSON-backed storage, note data should remain aligned with the right deck and card, and imported images should be stored in a dedicated images folder with stable names. This sprint turns that file contract into a real implementation target.

## Requirements

### Functional Requirements

- [ ] Define the on-device deck folder layout for content, notes, and images
- [ ] Store each deck's flashcard content in a deck-scoped JSON file
- [ ] Store each deck's note content in a deck-scoped JSON file keyed by card IDs or note IDs
- [ ] Store imported images in a deck-scoped images directory with generated stable filenames
- [ ] Define the relationship between JSON content storage and any SwiftData index or cache model
- [ ] Support reading, writing, and updating deck payloads atomically
- [ ] Support future migration/versioning of stored deck formats

### Non-Functional Requirements

- [ ] Storage updates must be resilient against partial writes and app interruptions
- [ ] File naming must remain stable enough for future sync and sharing workflows
- [ ] The storage layer must not depend on online services
- [ ] The contract must be easy to inspect and debug during development
- [ ] The implementation must allow later encryption or protection enhancements if needed

## Dependencies

- **Sprints**: 1
- **External**: None

## Scope

### In Scope

- Local folder/file layout
- Deck JSON and note JSON contracts
- Image naming strategy
- Persistence services and storage abstractions
- SwiftData usage only where it helps indexing or UI queries

### Out of Scope

- Final deck editing UI
- Final note editing UI
- Cloud sync implementation
- AI usage storage

## Technical Approach

Create a deck-scoped storage model such as `Decks/<deck-id>/cards.json`, `Decks/<deck-id>/notes.json`, and `Decks/<deck-id>/images/`. Keep display names separate from stable identifiers. Use JSON as the canonical content source because that aligns with your requirement and makes export/import easier. If SwiftData is used, treat it as a local index/cache or query helper rather than the sole source of truth.

Write persistence services that validate models before save, write to a temporary file first, then replace the live file. Store image references by generated asset IDs rather than original filenames.

## Tasks

### Phase 1: Planning

- [ ] Finalize the deck folder layout and file naming rules
- [ ] Finalize canonical schemas for cards and note payloads
- [ ] Define the role of SwiftData versus raw file storage

### Phase 2: Implementation

- [ ] Implement models and codecs for deck JSON and note JSON
- [ ] Implement image asset reference rules and storage helpers
- [ ] Implement safe local read/write/update operations for deck data

### Phase 3: Validation

- [ ] Validate that deck renames do not break card, note, or image references
- [ ] Validate that interrupted writes cannot corrupt the canonical files easily

### Phase 4: Documentation

- [ ] Document the local storage contract for later UI and sync sprints

## Acceptance Criteria

- [ ] A canonical local storage layout exists for decks, notes, and images
- [ ] The persistence layer can read and write deck-scoped JSON safely
- [ ] Image references are based on stable generated identifiers
- [ ] The storage contract is ready for the CRUD and note UI work in later sprints
- [ ] Sprint 4 and Sprint 5 can build against the storage contract without redefining it

## Notes

Created: 2026-03-26
