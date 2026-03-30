---
sprint: 13
title: "Multi-provider AI abstraction with deck-grounded chat"
type: fullstack
epic: 5
status: done
created: 2026-03-26T16:02:33Z
started: 2026-03-29T17:15:41Z
completed: 2026-03-29
hours: null
workflow_version: "3.1.0"


---

# Sprint 13: Multi-provider AI abstraction with deck-grounded chat

## Overview

| Field | Value |
|-------|-------|
| Sprint | 13 |
| Title | Multi-provider AI abstraction with deck-grounded chat |
| Type | fullstack |
| Epic | 5 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Build the AI integration layer that can route requests across multiple providers while grounding responses in one or more selected GradeFlip decks.

## Background

You want the AI assistant to work with ChatGPT, Claude, Gemini, Grok, and DeepSeek rather than locking the product to one vendor. You also want a constrained mode that answers only from the selected decks the user is currently working with, including support for selecting one, two, three, or more decks at once.

## Requirements

### Functional Requirements

- [ ] Support a shared provider abstraction for ChatGPT, Claude, Gemini, Grok, and DeepSeek
- [ ] Support provider/model configuration without rewriting the app for each vendor
- [ ] Support deck-grounded chat that uses one or more selected decks as the answer context
- [ ] Support choosing which decks are active for the current AI session
- [ ] Build a context-packaging pipeline that turns deck/card/note content into AI-ready prompt material
- [ ] Capture provider usage metadata needed later for token billing and analytics
- [ ] Keep deck-grounded mode constrained to selected GradeFlip content rather than open web knowledge
- [ ] The app scaffold gains a usable deck-grounded AI entry point during the sprint

### Non-Functional Requirements

- [ ] Provider switching must not change the app's high-level AI UX contract
- [ ] Deck grounding must be deterministic enough to debug and improve
- [ ] The integration layer must support later web-enabled mode without breaking deck-only mode
- [ ] Sensitive keys and provider credentials must not live in insecure client-side code
- [ ] The architecture must support future rate limits, retries, and fallback behavior

## Dependencies

- **Sprints**: 1, 2, 3, 4, 5, 6
- **External**: Provider API credentials and service setup

## Scope

### In Scope

- Shared AI provider abstraction
- Deck selection model for AI sessions
- Deck-grounded context building
- Provider usage metadata capture

### Out of Scope

- Open-web answer mode
- Token gifting and purchase flows
- Final provider pricing logic
- Advanced retrieval or fine-tuning work beyond the initial grounding layer

## Technical Approach

Create a provider interface that normalizes request creation, response parsing, usage metadata, and error handling. Build a context builder that can gather content from one or many selected decks and convert it into a bounded prompt package. Treat deck-grounded mode as a constrained context mode, not as general web search.

## Tasks

### Phase 1: Planning

- [ ] Define the provider interface and capability matrix
- [ ] Define how selected decks are represented in an AI session
- [ ] Define how deck content is transformed into prompt context

### Phase 2: Implementation

- [ ] Implement the shared provider abstraction
- [ ] Implement multi-deck context selection and packaging
- [ ] Implement usage metadata capture for later billing
- [ ] Integrate deck-grounded AI entry and response surfaces into the app shell

### Phase 3: Validation

- [ ] Validate that one-deck and multi-deck sessions both work as intended
- [ ] Validate that deck-grounded mode stays constrained to selected content
- [ ] Validate that provider-specific differences do not leak into the core app model

### Phase 4: Documentation

- [ ] Document the provider abstraction and deck-grounding contract for Sprint 14

## Acceptance Criteria

- [ ] GradeFlip can route deck-grounded AI requests through a shared provider abstraction
- [ ] Users can choose one or more decks for the current AI conversation
- [ ] Deck-grounded responses are built from selected GradeFlip content rather than web search
- [ ] Provider usage metadata is captured for later token accounting
- [ ] Sprint 14 can add billing and web-enabled mode on top of this layer
- [ ] The app exposes a testable deck-grounded AI flow after this sprint

## Notes

Created: 2026-03-26
