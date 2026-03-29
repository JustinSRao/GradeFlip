# GradeFlip Local CRUD Flows

## Purpose

This document captures the Sprint 4 local deck and flashcard CRUD behavior.

## Deck Operations

The local deck library supports:

- create deck
- rename deck
- delete deck
- list deck metadata for browsing

Deck renames update deck metadata only. Flashcards remain attached through stable `deckID` values and do not require relationship rewrites.

## Flashcard Operations

The local deck library supports:

- create flashcard inside a deck
- edit existing flashcard front text
- edit existing flashcard back text
- delete flashcard

Deleting a flashcard also removes:

- card-linked notes from the deck note payload
- card-linked image metadata from the deck content payload

## Delete Confirmation Rule

Destructive deck and flashcard actions must remain behind an explicit confirmation surface in the app layer. The storage layer performs the deletion, but the feature flow is responsible for the confirmation step.

## Deck Browsing Metadata

The deck list is driven from `LocalDeckIndexSnapshot` and currently exposes:

- deck title
- card count
- note count
- image count
- updated-at timestamp

This is the minimum metadata needed for browse surfaces in the local app before notes and images become first-class UI features in later sprints.
