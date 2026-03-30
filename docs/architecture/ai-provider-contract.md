# AI Provider Contract

## Purpose

This document defines the provider abstraction introduced in Sprint 13 so GradeFlip can support multiple vendors without rewriting the app’s AI surface for each one.

## Shared Contract

- A provider exposes one or more `AIModelDescriptor` values.
- Models declare whether they support deck grounding and web-enabled mode.
- The app sends a unified `AIChatRequest` with:
  - mode
  - selected model
  - message history
  - optional deck-grounding package
  - reserved output token ceiling

## Deck Grounding

- Deck-grounded mode uses only selected GradeFlip decks as context.
- The grounding package is produced from deck title, flashcard front/back text, and note content.
- Grounding is deterministic so later debugging can explain why the AI saw a given context block.

## Future Provider Implementation Rules

- Provider credentials must stay outside insecure client code.
- Provider-specific quirks should be normalized behind the shared request and response contract.
- Later rate limiting, retries, and fallbacks should attach to this layer rather than leaking into UI code.
