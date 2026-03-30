---
sprint: 9
title: "Mac app layout, themes, dark mode, and accessibility polish"
type: fullstack
epic: 3
status: in-progress
created: 2026-03-26T16:02:33Z
started: 2026-03-29T17:07:03Z
completed: null
hours: null
workflow_version: "3.1.0"

---

# Sprint 9: Mac app layout, themes, dark mode, and accessibility polish

## Overview

| Field | Value |
|-------|-------|
| Sprint | 9 |
| Title | Mac app layout, themes, dark mode, and accessibility polish |
| Type | fullstack |
| Epic | 3 |
| Status | Planning |
| Created | 2026-03-26 |
| Started | - |
| Completed | - |

## Goal

Deliver the Mac-specific experience with desktop-appropriate layout, theme customization, dark/light mode support, and accessibility-aware polish.

## Background

The Mac app should not feel like an oversized tablet shell. You also requested broad theme customization and both light and dark mode. This sprint is where the product becomes a serious Mac app rather than just a compatible build target.

## Requirements

### Functional Requirements

- [ ] Provide a Mac-specific layout for deck browsing, editing, and studying
- [ ] Support dark mode and light mode throughout the Mac experience
- [ ] Support the requested theme palette options: pink, red, orange, yellow, lime, green, cyan, baby blue, blue, navy blue, purple, magenta, and light pink
- [ ] Support desktop-friendly navigation, selection behavior, and keyboard shortcuts where appropriate
- [ ] Preserve note, image, and study interactions in the Mac layout
- [ ] Include accessibility improvements appropriate for larger displays and desktop interaction models
- [ ] Deliver a real Mac app shell suitable for later release validation

### Non-Functional Requirements

- [ ] Theme choices must remain coherent and readable in both dark and light appearances
- [ ] Keyboard interaction must feel natural on Mac
- [ ] The UI must remain visually intentional rather than default desktop boilerplate
- [ ] Accessibility improvements must cover color contrast, text readability, and navigation clarity
- [ ] The shared codebase must remain maintainable despite platform divergence

## Dependencies

- **Sprints**: 4, 5, 6, 7, 8
- **External**: None

## Scope

### In Scope

- Mac-specific layout and interaction model
- Dark/light mode coverage
- Theme customization system
- Accessibility and keyboard polish

### Out of Scope

- Online messaging features
- AI chat windows
- Final App Store launch assets
- Deep analytics instrumentation

## Technical Approach

Use a Mac-appropriate window and navigation structure that favors density, keyboard interaction, and simultaneous context over the phone and tablet models. Build theming as a reusable system of semantic color choices rather than view-by-view hardcoding. Verify that lined-paper notes, card surfaces, and image viewers remain readable across themes and appearances.

## Tasks

### Phase 1: Planning

- [ ] Define the Mac information architecture and keyboard behaviors
- [ ] Define the semantic theme system and supported palette mapping
- [ ] Define the accessibility targets for contrast and readability

### Phase 2: Implementation

- [ ] Implement the Mac layout and desktop navigation patterns
- [ ] Implement dark/light support and user-selectable themes
- [ ] Implement accessibility and keyboard refinements
- [ ] Wire the Mac presentation into the shared app shell with desktop-first behaviors

### Phase 3: Validation

- [ ] Validate theme readability across light and dark mode
- [ ] Validate keyboard and pointer interactions for major flows
- [ ] Validate that notes, cards, and images remain usable on Mac

### Phase 4: Documentation

- [ ] Document the theme system and Mac-specific interaction patterns

## Acceptance Criteria

- [ ] GradeFlip has a desktop-appropriate Mac experience
- [ ] Users can switch between dark/light mode and the requested color themes
- [ ] Core study, note, and image flows work cleanly on Mac
- [ ] Accessibility and keyboard behavior have been explicitly considered
- [ ] The app has distinct UI treatments for phone, iPad, and Mac
- [ ] The Mac build surface is ready for platform QA rather than deferred scaffolding

## Notes

Created: 2026-03-26
