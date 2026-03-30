# GradeFlip Image Attachment Contract

## Purpose

This document captures the Sprint 6 image attachment behavior.

## Storage Rules

Images are stored in the deck-scoped `images/` directory under generated canonical filenames:

```text
<image-asset-id>.<lowercased-extension>
```

The flashcard stores only stable image asset identifiers, while the deck content payload stores the `ImageAsset` records that resolve those identifiers to file metadata.

## Import Rules

- import is card-scoped
- generated filenames are required
- original filenames are preserved only as metadata
- image copy occurs before the updated deck snapshot is committed

## Removal Rules

- image removal requires explicit UI confirmation
- removing an image clears both the flashcard image reference and the deck image metadata record
- deleting a flashcard also removes its image metadata and image files

## UI Rules

- cards should expose a compact image affordance instead of large inline media by default
- preview opens a focused enlarged view
- missing-image states must degrade gracefully

## Sync Readiness

The local image model keeps storage concerns and reference concerns separate so future sync and sharing work can move image metadata and image binaries independently.
