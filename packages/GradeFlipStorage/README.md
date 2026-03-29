# GradeFlipStorage

This package will host local persistence for GradeFlip.

Planned responsibilities:

- deck JSON codecs
- note JSON codecs
- local file layout helpers
- image asset storage
- persistence migration/versioning support
- safe atomic file writes

Current Sprint 2 deliverables:

- `StoredDeckContents` and `StoredDeckNotes` as canonical JSON payloads
- `LocalDeckFileStore` for deck-scoped save/load/delete operations
- stable image filename generation and deck image persistence
- `LocalDeckStorageConfiguration` and `LocalDeckIndexSnapshot` so the app layer can bootstrap storage now and mirror a future SwiftData cache later
