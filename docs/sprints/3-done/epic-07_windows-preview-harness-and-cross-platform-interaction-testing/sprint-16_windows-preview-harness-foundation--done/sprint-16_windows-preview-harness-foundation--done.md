---
sprint: 16
title: "Windows desktop or web preview harness foundation for offline interaction testing"
type: fullstack
epic: 7
status: done
created: 2026-03-29T00:00:00Z
started: 2026-03-29T17:31:57Z
completed: 2026-03-29
hours: null
workflow_version: "3.1.0"


---

# Sprint 16: Windows desktop or web preview harness foundation for offline interaction testing

## Overview

| Field | Value |
|-------|-------|
| Sprint | 16 |
| Title | Windows desktop or web preview harness foundation for offline interaction testing |
| Type | fullstack |
| Epic | 7 |
| Status | Planning |
| Created | 2026-03-29 |
| Started | - |
| Completed | - |

## Goal

Create the first Windows-runnable GradeFlip preview target so offline interactions can be exercised without Apple runtimes.

## Background

The real product remains a native Apple app, but Windows-only development currently cannot validate the UI shell directly. A temporary preview harness would let you interact with the product model from Windows, reduce blind spots between package tests and Apple runtime testing, and make it easier to verify changes before Mac access is available.

## Requirements

### Functional Requirements

- [ ] Add a Windows-runnable preview target using a desktop or local web harness
- [ ] Reuse shared product state and sample data instead of creating a disconnected mock app
- [ ] Expose deck browsing, deck editing, note editing, image preview placeholders, and study flow entry points
- [ ] Keep the harness local-only and focused on the offline slice in its first iteration
- [ ] Keep the preview target clearly labeled as non-shipping infrastructure
- [ ] Integrate the harness into repo documentation and developer workflow

### Non-Functional Requirements

- [ ] The harness should be quick to launch from Windows
- [ ] The harness should minimize duplication with the Apple app scaffolds
- [ ] The preview target should not introduce new production dependencies without clear value
- [ ] The architecture should allow the harness to be removed later if native Apple validation fully replaces it

## Dependencies

- **Sprints**: 1, 4, 5, 6, 7, 8, 9
- **External**: None

## Scope

### In Scope

- Preview target selection and scaffold
- Windows launch instructions
- Offline feature entry points for deck/edit/study flows
- Shared sample-state wiring

### Out of Scope

- Real Apple runtime validation
- Production backend credentials
- App Store packaging
- Full parity with every online and AI flow

## Technical Approach

Choose the simplest Windows-runnable harness that can present GradeFlip interactions with low duplication, likely as a lightweight local web surface or another cross-platform preview container. Treat the harness as a testing adapter around the shared app/package state, not as a second production app.

## Tasks

### Phase 1: Planning

- [ ] Choose the harness technology and startup workflow
- [ ] Define the shared state boundary between the Apple app and the harness
- [ ] Define how sample fixtures feed the harness

### Phase 2: Implementation

- [ ] Create the preview harness project structure
- [ ] Wire deck browsing, deck editing, note, image, and study entry points
- [ ] Connect the harness to shared sample state and launch instructions

### Phase 3: Validation

- [ ] Validate that the harness launches from Windows
- [ ] Validate that the harness can exercise the core offline flow without Apple tooling
- [ ] Validate that the harness stays clearly separated from production Apple targets

### Phase 4: Documentation

- [ ] Document setup, scope limits, and the role of the preview harness in the development workflow

## Acceptance Criteria

- [ ] A Windows developer can launch a GradeFlip preview harness locally
- [ ] The harness can exercise the main offline interactions at a smoke-test level
- [ ] The harness reuses shared product concepts rather than inventing alternate behavior
- [ ] The repo documents that the harness complements but does not replace Apple validation

## Notes

Created: 2026-03-29
