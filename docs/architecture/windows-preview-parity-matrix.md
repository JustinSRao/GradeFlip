# Windows Preview Parity Matrix

## Purpose

This matrix defines what the Windows preview harness does and does not cover after Sprint 17.

## Covered In The Harness

- deck browsing
- deck title and card editing
- note editing
- image placeholder visibility
- study-card flip loop
- online shell states with representative sync and social feed posture
- AI shell states with representative provider, mode, and token estimate posture

## Not Covered In The Harness

- native Apple navigation and layout behavior
- StoreKit runtime behavior
- push notifications
- real backend authentication
- real AI provider calls
- signing, entitlements, or App Store packaging

## How To Use It

- Use the harness for smoke checks and interaction sanity from Windows.
- Use shared Swift tests for business logic.
- Use macOS for final runtime QA, StoreKit validation, and release submission work.
