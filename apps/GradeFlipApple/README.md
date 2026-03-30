# GradeFlipApple

This module hosts the Apple-platform application scaffold for GradeFlip.

Current scaffold:

- `App/GradeFlipAppleApp.swift`
- `App/GradeFlipRootView.swift`
- `GradeFlipApple.xcodeproj`
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

Open from Xcode using either:

- `GradeFlip.xcworkspace` at the repo root
- `apps/GradeFlipApple/GradeFlipApple.xcodeproj`

Notes:

- The project links the local Swift package at the repo root.
- Final runtime validation still needs to happen on macOS because this project was scaffolded from Windows and has not been built in Xcode here.
