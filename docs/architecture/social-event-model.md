# Social Event Model

## Purpose

This document defines the structured social event layer introduced in Epic 4 so messaging, deck shares, requests, likes, token gifts, and later notifications can use the same event stream.

## Event Types

- `buddyRequest`
- `buddyAccepted`
- `deckShare`
- `deckRequest`
- `deckLike`
- `tokenGift`

## Rules

- Study buddy relationships only exist after an explicit request is accepted.
- Deck ownership remains separate from shared access.
- Shared deck access records who shared what, to whom, and whether the recipient can copy the deck into their own library.
- Likes are attributable to both the acting user and the original deck owner.
- Social feed entries should be safe to render without exposing private deck contents by default.

## Messaging Tab Assumption

- The app’s messaging or social tab should be able to render a chronological list of social events.
- Rich real-time chat is not required for the current implementation.
- Token gifts in Sprint 14 should reuse the same event stream rather than creating a separate notification system.
