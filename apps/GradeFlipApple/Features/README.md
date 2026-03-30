# GradeFlipApple Features

This folder is the app-facing integration surface for feature work.

Rule:

- When a sprint adds storage, billing, sync, AI, or UI functionality, it should also add or update the corresponding feature files here instead of leaving the work isolated in packages.

Current feature slices:

- `DeckManagement/` for Sprint 4 local deck and flashcard CRUD scaffolding
- `DeckManagement/DeckNotesFeatureView.swift` for Sprint 5 per-card note editing and lined-paper presentation
- `DeckManagement/CardImagesFeatureView.swift` for Sprint 6 image attachment, preview, and delete confirmation scaffolding
- `Study/IPhoneStudyFeatureView.swift` for Sprint 7 phone-first study flow and note/image affordances
- `Study/IPadStudyWorkspaceView.swift` for Sprint 8 multi-pane iPad study workspace
- `Study/MacStudyExperienceView.swift` for Sprint 9 Mac layout, themes, and keyboard-first presentation
- `Study/StudyFlipCardView.swift` for the shared flashcard flip interaction
- `Study/StudyTheme.swift` for the requested palette system across Apple surfaces
