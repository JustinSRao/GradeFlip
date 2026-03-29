# GradeFlip Local Storage Contract

## Purpose

This document is the canonical local persistence contract delivered by Sprint 2.

## Canonical Storage Model

GradeFlip stores local study content under a deck-scoped folder layout:

```text
<root>/
  Decks/
    <deck-id>/
      cards.json
      notes.json
      images/
        <image-asset-id>.<ext>
```

JSON remains the canonical local source of truth. SwiftData is intentionally treated as a future Apple-platform index/cache layer for UI queries rather than the source of record.

## cards.json

`cards.json` stores a `StoredDeckContents` payload:

- `schemaVersion`
- `deck`
- `cards`
- `imageAssets`
- `savedAt`

This keeps deck metadata, flashcards, and image references aligned in a single deck-scoped file.

## notes.json

`notes.json` stores a `StoredDeckNotes` payload:

- `schemaVersion`
- `deckID`
- `notes`
- `savedAt`

Notes remain deck-scoped and card-linked by stable identifiers.

## Images

Imported image files are copied into the deck `images/` directory using generated canonical filenames:

```text
<image-asset-id>.<lowercased-original-extension>
```

This preserves stable references across deck renames, future sync, and sharing workflows.

## Atomic Write Strategy

The storage layer writes JSON and image data through a temporary file and then replaces or moves it into place. This reduces the chance of leaving a partially-written canonical file behind.

## Protection Strategy

The storage configuration records a desired protection mode:

- `none`
- `completeUntilFirstUserAuthentication`

On Apple platforms, the store is prepared to apply file protection resource values. On Windows, that protection setting is preserved in configuration but treated as a no-op so the storage package stays portable.

## App Integration Rule

Sprint 2 does not leave persistence isolated inside a package. The app layer should consume a `LocalDeckStorageConfiguration`, bootstrap the storage root, and derive index snapshots that a future SwiftData cache can mirror for UI presentation.
