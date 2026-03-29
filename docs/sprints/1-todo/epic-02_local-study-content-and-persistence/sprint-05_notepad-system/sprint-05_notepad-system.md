---
sprint: 5
title: "Notepad system with lined paper styling and per-card notes"
type: fullstack
epic: 2
status: planning
created: 2026-03-26T16:02:32Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 5: Notepad system with lined paper styling and per-card notes

## Overview

| Field | Value |
|-------|-------|
| Sprint | 5 |
| Title | Notepad system with lined paper styling and per-card notes |
| Type | fullstack |
| Epic | 2 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Implement GradeFlip's note-taking experience with lined-paper styling, per-card note storage, and speech-to-text note entry on supported devices.

## Background

Notes are central to the app concept, not a side feature. Each flashcard should have its own notepad, and note content needs to remain aligned with the correct deck and card. You also want voice-to-text for note entry, which affects the editor design.

## Requirements

### Functional Requirements

- [ ] Each flashcard can open and edit its own note content
- [ ] Note content is stored in the deck's note JSON file rather than scattered across unrelated storage
- [ ] The note editor visually resembles lined paper
- [ ] Users can return to previously saved note content without losing formatting or structure
- [ ] The app supports speech-to-text note entry on supported Apple platforms
- [ ] The note system can support deck-scoped note data keyed to stable card IDs
- [ ] The note editor can be embedded later into phone, tablet, and Mac-specific layouts
- [ ] The app scaffold gains a reachable note-editing surface during this sprint

### Non-Functional Requirements

- [ ] Note editing must feel responsive for long-form text entry
- [ ] The lined-paper presentation must remain readable in light and dark mode
- [ ] Dictation support must fail gracefully when unavailable or denied
- [ ] Note persistence must be reliable under repeated edits
- [ ] The design must be compatible with later sharing or sync expansion

## Dependencies

- **Sprints**: 2, 4
- **External**: Apple speech/dictation support on device

## Scope

### In Scope

- Per-card note model
- Lined-paper note editor styling
- Note persistence wiring
- Speech-to-text input support for notes

### Out of Scope

- Image attachments
- Online shared notes
- AI note generation
- Final iPad or Mac-specific note layout optimizations

## Technical Approach

Represent note content as deck-scoped data keyed by stable card identifiers. Keep the visual lined-paper effect in the presentation layer instead of baking layout artifacts into stored content. Build the note editor so text entry, dictation input, and autosave all feed into the same persistence path.

## Tasks

### Phase 1: Planning

- [ ] Define the note data shape and how it maps to card IDs
- [ ] Define the lined-paper styling rules for light and dark mode
- [ ] Define the dictation entry behavior and error states

### Phase 2: Implementation

- [ ] Implement per-card note retrieval and save flows
- [ ] Implement the lined-paper note editor presentation
- [ ] Implement speech-to-text entry support for notes
- [ ] Integrate the note editor into the app shell for deck/card flows

### Phase 3: Validation

- [ ] Validate that each card opens the correct note content consistently
- [ ] Validate note persistence across repeated edits and app restarts
- [ ] Validate readable lined-paper styling in both light and dark appearances

### Phase 4: Documentation

- [ ] Document the note model and dictation assumptions for later UI work

## Acceptance Criteria

- [ ] Each flashcard has its own editable note area
- [ ] Note data is stored in deck-scoped JSON and remains aligned to the correct card
- [ ] The note editor presents as lined paper
- [ ] Speech-to-text note entry works on supported devices
- [ ] The note system is ready for integration into all three platform-specific UIs
- [ ] Notes are testable from the app scaffold without requiring later integration work

## Notes

Created: 2026-03-26
