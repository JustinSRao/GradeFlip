---
epic: 1
title: "Foundation and Apple architecture"
status: done
created: 2026-03-26
started: null
completed: 2026-03-29T16:35:24Z

total_hours: 0.0
---

# Epic 01: Foundation and Apple architecture

## Overview

Establish the technical foundation for GradeFlip as a native Apple-platform study app with a one-time paid core product, optional subscription-backed online features, and an extensible AI integration layer. This epic locks the architecture, data boundaries, persistence strategy, and monetization structure needed before feature delivery can scale safely across iPhone, iPad, and Mac.

## Success Criteria

- [ ] A clear native Apple architecture is chosen and documented for iPhone, iPad, and Mac targets
- [ ] Local-first storage boundaries are defined for decks, flashcards, notes, and images
- [ ] Online-only capabilities are separated cleanly from the paid core app experience
- [ ] Purchase and subscription gates are designed so offline and online features can coexist cleanly
- [ ] The foundation epic leaves behind real app scaffolding instead of package-only groundwork
- [ ] The first implementation sprints can proceed without revisiting foundational product decisions

## Sprints

| Sprint | Title | Status |
|--------|-------|--------|
| 1 | Product architecture, data model, and repository scaffolding | planned |
| 2 | SwiftData and JSON storage pipeline for decks, cards, notes, and images | planned |
| 3 | StoreKit purchase model, app modes, and feature gating foundation | planned |

## Backlog

- [ ] Define Apple-platform target structure and shared domain modules
- [ ] Define local file layout for deck JSON, note JSON, and image assets
- [ ] Define the separation between local mode, online mode, and AI token usage
- [ ] Define Windows authoring expectations and the required macOS validation path
- [ ] Confirm backend choice for online sync, messaging, subscriptions, and token ledger

## Notes

Created: 2026-03-26
