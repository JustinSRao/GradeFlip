---
epic: 2
title: "Local study content and persistence"
status: planning
created: 2026-03-26
started: null
completed: null
---

# Epic 02: Local study content and persistence

## Overview

Deliver the offline-first core study experience that users receive with the one-time App Store purchase. This epic covers creating and editing decks and flashcards, writing per-card notes on lined paper, storing deck data locally in JSON, and attaching card images that stay aligned to the right card.

## Success Criteria

- [ ] Users can create, edit, and delete decks and flashcards locally
- [ ] Deck renames propagate cleanly because cards reference stable deck IDs rather than copied deck names
- [ ] Every flashcard can have its own notepad content, stored locally and recoverably
- [ ] Imported images are auto-renamed, stored predictably, and previewable from the card UI
- [ ] The local storage contract is robust enough to support later cloud sync

## Sprints

| Sprint | Title | Status |
|--------|-------|--------|
| 4 | Deck, flashcard, and deck editing flows | planned |
| 5 | Notepad system with lined paper styling and per-card notes | planned |
| 6 | Image import, auto-rename, preview, and delete safeguards | planned |

## Backlog

- [ ] Build deck CRUD and flashcard CRUD on top of the local persistence layer
- [ ] Store per-card note content in deck-scoped note JSON files
- [ ] Support speech dictation for note entry on supported Apple platforms
- [ ] Store imported images in deck-scoped image folders with stable generated names

## Notes

Created: 2026-03-26
