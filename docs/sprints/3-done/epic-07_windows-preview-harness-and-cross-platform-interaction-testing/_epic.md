---
epic: 7
title: "Windows preview harness and cross-platform interaction testing"
status: done
created: 2026-03-29
started: null
completed: 2026-03-29T17:38:26Z

total_hours: 0.0

---

# Epic 07: Windows preview harness and cross-platform interaction testing

## Overview

Add a temporary desktop or web preview harness that runs on Windows so GradeFlip interactions can be exercised before a Mac is available, while keeping the harness clearly separate from the real Apple release target.

## Success Criteria

- [ ] GradeFlip has a runnable Windows-friendly preview surface for offline interaction testing
- [ ] The preview harness reuses shared domain and package logic rather than forking product rules
- [ ] Core deck editing, note, image, and study interactions can be smoke-tested outside Apple runtimes
- [ ] The repo clearly documents that the harness is a development aid, not a shipping replacement for iPhone, iPad, or Mac validation
- [ ] Preview-specific work does not weaken the release-ready Apple path already established by Epic 6
- [ ] The harness can later be removed or reduced without destabilizing the shared product code

## Sprints

| Sprint | Title | Status |
|--------|-------|--------|
| 16 | Windows desktop or web preview harness foundation for offline interaction testing | planned |
| 17 | Preview harness parity for study, deck editing, and smoke-test flows | planned |

## Backlog

- [ ] Choose the harness shape: lightweight desktop shell, local web app, or equivalent Windows-runnable preview target
- [ ] Reuse shared storage, billing, online, and AI state models where practical
- [ ] Add smoke-test fixtures for deck browsing, editing, studying, notes, and image flows
- [ ] Document the boundary between preview validation and required Apple runtime validation

## Notes

Created: 2026-03-29
