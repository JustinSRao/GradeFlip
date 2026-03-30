# Windows Preview Harness

## Purpose

The Windows preview harness provides a local interaction surface for GradeFlip when a developer only has a Windows machine available.

## Current Shape

- local static web app
- launched from Python's built-in HTTP server
- driven by shared repository sample fixtures rather than production services

## Current Coverage

- deck browsing
- deck editing
- note editing
- image placeholder visibility
- study-card flip flow
- online shell state previews
- AI shell state previews

## Boundaries

- It is not a shipping target.
- It does not validate Apple navigation containers, StoreKit, signing, or platform runtime behavior.
- It complements shared Swift tests and later macOS validation.

## Windows Workflow

Launch:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-preview-web.ps1
```

Smoke test:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\preview-smoke.ps1
```
