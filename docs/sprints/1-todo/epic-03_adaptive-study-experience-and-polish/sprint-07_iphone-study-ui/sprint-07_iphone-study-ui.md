---
sprint: 7
title: "iPhone study UI with realistic flashcard flip interaction"
type: fullstack
epic: 3
status: planning
created: 2026-03-26T16:02:32Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 7: iPhone study UI with realistic flashcard flip interaction

## Overview

| Field | Value |
|-------|-------|
| Sprint | 7 |
| Title | iPhone study UI with realistic flashcard flip interaction |
| Type | fullstack |
| Epic | 3 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Create the phone-first GradeFlip study experience with a polished flashcard interaction model and an intentional iPhone-specific layout.

## Background

The flashcard interaction is one of the most visible parts of the app, and you explicitly want cards to flip nicely. The phone UI has to balance deck browsing, card review, note access, and image hints without feeling cramped.

## Requirements

### Functional Requirements

- [ ] Provide an iPhone-specific navigation flow for deck browsing, card review, and card editing access
- [ ] Implement a realistic flashcard flip interaction for studying a card front and back
- [ ] Support quick access to per-card notes from the phone study flow
- [ ] Support compact display of image attachments within the card experience
- [ ] Support create/edit entry points without overloading the study screen
- [ ] Preserve light and dark readability in the phone layout

### Non-Functional Requirements

- [ ] The flip interaction must feel smooth rather than mechanical or abrupt
- [ ] The phone layout must remain usable one-handed where practical
- [ ] Motion should enhance clarity instead of obscuring content
- [ ] The study experience must remain performant on typical iPhones
- [ ] The structure must be adaptable to later theme customization

## Dependencies

- **Sprints**: 4, 5, 6
- **External**: None

## Scope

### In Scope

- iPhone deck browsing and study flow
- Flashcard flip interaction
- Entry points to card notes and image preview
- Phone-specific spacing and layout decisions

### Out of Scope

- iPad workspace
- Mac-specific UI
- Online social features
- AI chat surfaces

## Technical Approach

Build an iPhone-first study flow with separate presentation states for browsing, reviewing, and editing. Use a controlled 3D-style flip interaction or equivalent animation that keeps text legible and state transitions predictable. Keep heavy editing surfaces off the primary study card where possible, routing deeper edits to dedicated screens or sheets.

## Tasks

### Phase 1: Planning

- [ ] Define the phone navigation model and study loop
- [ ] Define the flip animation states and edge cases
- [ ] Define where note and image entry points appear on the phone

### Phase 2: Implementation

- [ ] Implement the iPhone deck list and study screens
- [ ] Implement the flashcard flip interaction
- [ ] Integrate note and image affordances into the phone flow

### Phase 3: Validation

- [ ] Validate animation smoothness and readability
- [ ] Validate that note and image access does not break the study loop
- [ ] Validate phone usability in both light and dark mode

### Phase 4: Documentation

- [ ] Document the phone interaction patterns for the iPad and Mac follow-up work

## Acceptance Criteria

- [ ] GradeFlip has a clear iPhone-specific study flow
- [ ] Flashcards flip in a polished and understandable way
- [ ] Notes and image previews are reachable from the phone study experience
- [ ] The phone UI feels intentionally designed rather than stretched from a larger layout
- [ ] Sprint 8 and Sprint 9 can build on the established visual language

## Notes

Created: 2026-03-26
