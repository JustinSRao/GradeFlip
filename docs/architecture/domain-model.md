# GradeFlip Domain Model

## Design Rules

- Every major entity gets a stable identifier.
- Display names are editable and must not be used as primary linkage.
- Deck, card, note, and image relationships must survive renames.
- Local and cloud models should share stable IDs where feasible.

## Core Local Study Entities

### Deck

Purpose:
Owns a user-created collection of flashcards and associated note/image assets.

Suggested fields:

- `deckId`
- `title`
- `createdAt`
- `updatedAt`
- `themeOverride`
- `cardOrder`
- `isSynced`
- `remoteRevision`

### Flashcard

Purpose:
Represents a single study card in a deck.

Suggested fields:

- `cardId`
- `deckId`
- `frontText`
- `backText`
- `createdAt`
- `updatedAt`
- `noteId`
- `imageAssetIds`
- `studyMetadata`

### CardNote

Purpose:
Stores note content for an individual card.

Suggested fields:

- `noteId`
- `deckId`
- `cardId`
- `plainTextContent`
- `createdAt`
- `updatedAt`
- `dictationMetadata`

### ImageAsset

Purpose:
Represents a local or cloud-backed image attached to a flashcard.

Suggested fields:

- `imageAssetId`
- `deckId`
- `cardId`
- `canonicalFilename`
- `originalFilename`
- `mimeType`
- `createdAt`
- `updatedAt`
- `width`
- `height`

## User and Online Entities

### User

- `userId`
- `displayName`
- `email`
- `createdAt`
- `subscriptionState`
- `tokenBalance`

### BuddyRequest

- `requestId`
- `fromUserId`
- `toUserId`
- `status`
- `createdAt`
- `respondedAt`

### StudyBuddyRelationship

- `relationshipId`
- `userAId`
- `userBId`
- `createdAt`
- `status`

### SharedDeckAccess

- `shareId`
- `ownerUserId`
- `recipientUserId`
- `deckId`
- `permissionLevel`
- `createdAt`

### MessageEvent

- `messageEventId`
- `threadId`
- `senderUserId`
- `recipientUserId`
- `eventType`
- `payload`
- `createdAt`

Event types include:

- deck share
- deck request
- token gift
- social system message

### DeckLike

- `likeId`
- `deckId`
- `ownerUserId`
- `likedByUserId`
- `createdAt`

### StudyStreak

- `streakId`
- `userId`
- `buddyUserId`
- `currentCount`
- `lastQualifiedStudyDate`
- `status`

## AI and Billing Entities

### EntitlementSnapshot

- `userId`
- `hasPaidCoreAccess`
- `hasOnlineSubscription`
- `tokenBalance`
- `updatedAt`

### TokenLedgerEntry

- `ledgerEntryId`
- `userId`
- `entryType`
- `amount`
- `balanceAfter`
- `relatedMessageEventId`
- `relatedAIRequestId`
- `createdAt`

Entry types include:

- purchase
- spend
- gift_sent
- gift_received
- refund
- reconciliation_adjustment

### AISession

- `aiSessionId`
- `userId`
- `mode`
- `selectedDeckIds`
- `provider`
- `model`
- `createdAt`

Modes:

- `deck_grounded`
- `web_enabled`

### AIRequestUsage

- `aiRequestId`
- `aiSessionId`
- `provider`
- `model`
- `inputTokensEstimated`
- `outputTokensReserved`
- `inputTokensActual`
- `outputTokensActual`
- `estimatedTokenCharge`
- `actualTokenCharge`
- `surchargeType`
- `createdAt`

## Local File Model

Recommended local layout:

```text
Decks/
  <deck-id>/
    cards.json
    notes.json
    images/
      <image-asset-id>.<ext>
```

### `cards.json`

Stores:

- deck metadata
- flashcard list
- per-card references to notes and images

### `notes.json`

Stores:

- note records keyed by `noteId`
- relationships to `cardId`

### `images/`

Stores:

- actual copied image files using generated canonical names

## Relationship Summary

- One deck has many flashcards.
- One flashcard has zero or one note.
- One flashcard has zero or many image assets.
- One user has many decks.
- One user can have many buddy requests and many buddy relationships.
- One user can have many token ledger entries.
- One AI session can reference many selected decks.

## Important Invariants

- Renaming a deck must not require rewriting card ownership relationships.
- Removing a card must also remove or detach its note and image references intentionally.
- Image linkage must always be based on stable IDs, not display filenames.
- AI billing must reference ledger entries, not inferred UI events.
