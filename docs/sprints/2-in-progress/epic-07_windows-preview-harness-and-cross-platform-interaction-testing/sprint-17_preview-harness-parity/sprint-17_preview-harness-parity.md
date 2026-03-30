---
sprint: 17
title: "Preview harness parity for study, deck editing, and smoke-test flows"
type: fullstack
epic: 7
status: planning
created: 2026-03-29T00:00:00Z
started: null
completed: null
hours: null
workflow_version: "3.1.0"
---

# Sprint 17: Preview harness parity for study, deck editing, and smoke-test flows

## Overview

| Field | Value |
|-------|-------|
| Sprint | 17 |
| Title | Preview harness parity for study, deck editing, and smoke-test flows |
| Type | fullstack |
| Epic | 7 |
| Status | Planning |
| Created | 2026-03-29 |
| Started | - |
| Completed | - |

## Goal

Bring the Windows preview harness to a useful parity level for regular interaction testing across the main offline flows and selected online or AI shell states.

## Background

Once the harness exists, it needs enough parity to be genuinely useful for day-to-day validation. This sprint focuses on representative interactions and smoke-test posture rather than pixel-matching the Apple app.

## Requirements

### Functional Requirements

- [ ] Support representative deck management and study flows in the preview harness
- [ ] Support note and image affordance previews in the harness
- [ ] Support read-only or stubbed preview states for online and AI tabs where useful for integration testing
- [ ] Add smoke-test fixtures or scripts that verify harness startup and core navigation
- [ ] Document what parity exists and what still requires Apple runtime testing

### Non-Functional Requirements

- [ ] The harness should stay fast to iterate on from Windows
- [ ] The harness should favor behavioral coverage over visual duplication
- [ ] The harness should remain safe to use without production keys
- [ ] The parity work should not turn the harness into a second product roadmap

## Dependencies

- **Sprints**: 16
- **External**: None

## Scope

### In Scope

- Harness interaction parity for offline flows
- Smoke-test coverage for launch and navigation
- Optional stub states for online and AI shells
- Documentation of fidelity boundaries

### Out of Scope

- Replacing macOS simulator/device testing
- Shipping the harness to end users
- Full backend integration with production services

## Technical Approach

Extend the harness only far enough to make it a practical development aid. Prefer representative fixtures, shared view-model state, and repeatable smoke checks over exact platform styling. Keep a hard line between development preview utility and Apple release validation.

## Tasks

### Phase 1: Planning

- [ ] Define the parity target for deck/edit/study interactions
- [ ] Define which online and AI states should be stubbed in the harness
- [ ] Define smoke-test workflow for harness validation

### Phase 2: Implementation

- [ ] Expand the harness flows to cover the major offline paths
- [ ] Add preview states for online and AI shell integration as needed
- [ ] Add smoke-test fixtures or startup checks

### Phase 3: Validation

- [ ] Validate regular Windows interaction testing workflow
- [ ] Validate harness parity against the shared app concepts
- [ ] Validate that unsupported Apple-only behaviors are explicitly documented

### Phase 4: Documentation

- [ ] Document the harness parity matrix and remaining Apple-only validation requirements

## Acceptance Criteria

- [ ] The preview harness is useful for routine Windows interaction checks
- [ ] Core offline flows are represented well enough for smoke testing
- [ ] The repo clearly distinguishes harness parity from real Apple runtime QA
- [ ] The harness can be maintained as a development aid without expanding into a second shipping app

## Notes

Created: 2026-03-29
