# Study Surface Patterns

## Purpose

This document records the platform-specific study interaction model introduced across Sprint 7, Sprint 8, and Sprint 9 so later online and AI work can attach to the existing study shell instead of building another navigation stack.

## Phone

- The phone flow is a focused single-column experience.
- Deck selection stays in a horizontal deck picker instead of a nested menu.
- The flashcard is the primary object on screen.
- Notes and image attachments are secondary affordances behind compact actions or sheets.
- Card creation and deep editing stay on the separate deck-management surface.

## iPad

- The iPad flow uses a multi-pane workspace.
- Decks, cards, and supporting detail panels can stay visible together.
- The flip interaction stays intact, but supporting note and image context remains visible without replacing the study card.
- The layout is intended to remain useful in both portrait and landscape orientations.

## Mac

- The Mac flow uses a desktop-first split layout with keyboard shortcuts.
- Theme selection and light/dark preview are explicit surface controls.
- Card review, note reading, and image awareness stay visible at the same time.
- Presentation uses semantic theme tokens rather than hardcoded per-view colors.

## Shared Rules

- Flipping a card resets to the front when navigating to another card.
- Notes are previewable from study, but long-form editing remains on the editing surface.
- Image attachments stay compact inside study and can expand when needed.
- Theme choices must remain readable in both light and dark presentations.
- Later online and AI affordances should attach to the study shell without replacing its core browse-review-note loop.
