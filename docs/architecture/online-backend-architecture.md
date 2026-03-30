# Online Backend Architecture

## Backend Decision

GradeFlip currently standardizes on `Supabase + PostgreSQL` for the first online implementation.

Reasons:

- PostgreSQL fits the relational model required for users, decks, notes, images, subscriptions, friendships, messages, streaks, and token ledgers.
- Supabase gives managed authentication, storage, and row-level-security primitives that fit the current sprint scope.
- The backend choice remains documented, not hardcoded into the product model, so a future migration is still possible if business or operational constraints change.

## Core Rules

- Offline JSON storage remains the local source of truth for the paid-core app.
- Online sync reconciles local records with server-side records that preserve the same stable GradeFlip identifiers.
- Auth is optional for offline-only usage and required for sync or social features.
- Row-level security is assumed for user-owned content by default.
- Near-simultaneous updates should be flagged as merge conflicts; otherwise the newer side wins.

## Relational Surface

- `profiles`
- `decks`
- `flashcards`
- `card_notes`
- `image_assets`
- `buddy_requests`
- `study_buddies`
- `social_events`
- `shared_decks`
- `deck_likes`
- `subscription_entitlements`
- `study_activity_events`
- `study_streaks`
- `ai_token_ledger`

## App Integration

- The app shell exposes an Online tab during the sprint.
- The online shell must make sign-in state, sync posture, and social feed posture visible even before production credentials are attached.
- Later sprints should extend the same shell rather than creating another online navigation branch.
