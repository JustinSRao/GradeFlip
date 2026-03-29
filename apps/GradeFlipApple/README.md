# GradeFlipApple

This module hosts the Apple-platform application scaffold for GradeFlip.

Current scaffold:

- `App/GradeFlipAppleApp.swift`
- `App/GradeFlipRootView.swift`
- `Features/`
- `Resources/`

Responsibilities:

- app entry points
- SwiftUI scenes and navigation
- iPhone-specific UI composition
- iPad-specific UI composition
- macOS-specific UI composition
- platform integration points such as StoreKit surfaces, image pickers, and dictation UX

Rule:

- Feature sprints should wire new functionality into this app surface as they land instead of leaving the app assembly for the launch sprint.
