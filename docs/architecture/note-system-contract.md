# GradeFlip Note System Contract

## Purpose

This document captures the Sprint 5 note model and editor assumptions.

## Persistence Model

Notes remain in the deck-scoped `notes.json` payload and are keyed to stable `flashcardID` values.

Each note record stores:

- `noteId`
- `deckID`
- `flashcardID`
- `plainTextContent`

Flashcards may also carry an optional `noteID` reference so the card payload can point at the current note record without duplicating the note body in `cards.json`.

## Editor Rules

- Each flashcard owns at most one current note
- Editing a note updates the existing note record instead of appending duplicates
- Deleting a flashcard removes its associated note record
- The lined-paper presentation is visual only and is not serialized into the note content

## Dictation Rule

Sprint 5 provides a dictation-facing app scaffold and failure state model. Final Apple speech integration still depends on running on supported Apple platforms.

The UI must handle:

- dictation available
- dictation unavailable
- permission denied
- placeholder insertion and manual editing fallback

## UI Embedding Rule

The note editor must be reachable from the card-management flow now so later iPhone, iPad, and Mac study surfaces can reuse the same note-editing behavior rather than integrating it for the first time in a future sprint.
