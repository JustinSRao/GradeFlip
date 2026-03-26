---
sprint: 6
title: "Image import, auto-rename, preview, and delete safeguards"
type: fullstack
epic: 2
status: planning
created: 2026-03-26T16:02:32Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 6: Image import, auto-rename, preview, and delete safeguards

## Overview

| Field | Value |
|-------|-------|
| Sprint | 6 |
| Title | Image import, auto-rename, preview, and delete safeguards |
| Type | fullstack |
| Epic | 2 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Allow users to attach images to flashcards with stable generated filenames, compact preview behavior, enlarge-on-tap viewing, and safe removal flows.

## Background

Images are part of the flashcard value proposition, but they can corrupt local data integrity if card references and image files drift apart. You also want the UI behavior defined clearly: each card shows a tiny popup-style image affordance, and tapping it should enlarge the image.

## Requirements

### Functional Requirements

- [ ] Users can import an image for an individual flashcard
- [ ] Imported images are copied into a deck-scoped images folder
- [ ] Imported image files are auto-renamed to generated stable names rather than relying on the original filename
- [ ] Flashcards store image references through stable asset identifiers
- [ ] The flashcard UI can show a small image preview or indicator without dominating the card layout
- [ ] Tapping or selecting the image preview enlarges the image in a focused viewer
- [ ] Removing an attached image requires explicit confirmation
- [ ] Deleting or moving a card updates image relationships safely

### Non-Functional Requirements

- [ ] Large images must not freeze the UI during import
- [ ] The naming scheme must avoid collisions across cards and decks
- [ ] The preview behavior must work across phone, tablet, and desktop contexts
- [ ] Local file cleanup must avoid leaving obvious orphaned image files
- [ ] The implementation must remain compatible with later sharing or sync

## Dependencies

- **Sprints**: 2, 4
- **External**: Platform image picker APIs

## Scope

### In Scope

- Image import flow
- Stable renaming strategy
- Card-to-image reference model
- Small preview and enlarged viewer behavior
- Confirmation UX for image removal

### Out of Scope

- Social image sharing
- Image OCR or AI analysis
- Complex image editing tools
- Remote image storage

## Technical Approach

When a user imports an image, generate a stable asset ID, derive a canonical filename from that ID, and copy the file into the deck's image directory. Store only the generated asset reference in the card model. Build the UI around a small preview affordance that opens a larger modal, popover, or sheet depending on platform. Route image removal through a confirmation step and clean up storage references safely.

## Tasks

### Phase 1: Planning

- [ ] Define the asset ID and canonical filename rules
- [ ] Define the preview-versus-expanded image interaction across platforms
- [ ] Define image-removal confirmation and cleanup behavior

### Phase 2: Implementation

- [ ] Implement image import and canonical file copy behavior
- [ ] Implement image reference storage on flashcards
- [ ] Implement compact preview and enlarged viewer flows
- [ ] Implement safe image removal and cleanup

### Phase 3: Validation

- [ ] Validate that imported images remain aligned to the correct flashcard after edits
- [ ] Validate that removal confirmation appears before image deletion
- [ ] Validate that missing-image states degrade gracefully

### Phase 4: Documentation

- [ ] Document the image storage and cleanup rules for later sync work

## Acceptance Criteria

- [ ] Users can attach images to flashcards locally
- [ ] Imported images are stored with generated stable names in the deck image folder
- [ ] Flashcards show a compact image affordance and an enlarged view on interaction
- [ ] Image deletion is confirmed before the file relationship is removed
- [ ] The local image model is ready for future sync or sharing work

## Notes

Created: 2026-03-26
