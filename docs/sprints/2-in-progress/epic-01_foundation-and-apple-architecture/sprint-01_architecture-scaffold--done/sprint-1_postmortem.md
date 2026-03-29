# Sprint 1 Postmortem: Product architecture, data model, and repository scaffolding

## Metrics

| Metric | Value |
|--------|-------|
| Sprint Number | 1 |
| Started | 2026-03-26T16:20:10Z |
| Completed | Pending sprint completion automation |
| Duration | Pending completion automation |
| Steps Completed | 6 |
| Files Changed | 160 tracked files in implementation commit, plus postmortem file |
| Tests Added | 5 Swift test functions across 2 test files |
| Coverage Delta | Validation completed with 5 passing Swift tests on Windows after toolchain repair |

## What Went Well

- The architecture boundary work was concrete enough to turn into real docs rather than vague notes.
- The repo now has a usable module layout and a root Swift package manifest instead of only workflow files.
- The backlog was normalized to Sprint 1 through Sprint 15 and now has complete specifications for each sprint and epic.
- The foundation sprint now also records the Windows authoring versus macOS validation boundary instead of leaving platform testing assumptions implicit.
- The Windows Swift toolchain is now usable for package validation after upgrading to Swift 6.3 and wiring in the Windows XCTest library paths.
- The GitHub remote is now connected to a real local git repository.

## What Could Improve

- Shorter sprint folder/file slugs should have been chosen earlier to avoid Windows path-length failures in git.
- The Windows Swift test invocation should be scripted so the required MSVC and XCTest paths are not reconstructed manually each time.
- Generated Python bytecode and other workflow bootstrap artifacts should be reviewed before the first implementation commit to keep the history cleaner.

## Blockers Encountered

- The initial workflow registration bug advanced sprint numbering to 16 through 30 before valid sprint files existed.
- Windows git path-length limits blocked the first implementation commit until sprint slugs were shortened.
- The initial Swift 6.2.4 install was unusable and had to be upgraded before package tests could run.
- The project was not initially a git repository, so git initialization and remote wiring had to be added during the sprint.

## Technical Insights

- GradeFlip benefits from a strict separation between offline core, subscription-backed online features, and AI token usage.
- `Supabase + PostgreSQL` is the current best-fit backend recommendation for the product's social, billing, and ledger-heavy shape, but the decision can still be revised before the online sprint if the project docs are updated consistently.
- Stable IDs for decks, flashcards, notes, and image assets are essential because deck renames, image alignment, sharing, and AI deck selection all depend on them.
- Windows path limits can affect workflow-generated sprint file structures if slugs are too verbose.
- Release readiness has to be designed into the sprint sequence early; it should not be deferred to a final cleanup pass.

## Process Insights

- The sprint workflow can move quickly once the backlog and numbering are corrected, but environment validation should happen before depending on test steps.
- Separating the implementation commit from the completion automation makes the close-out flow cleaner and easier to reason about.
- Postmortem generation is more useful when the template is filled immediately rather than left as boilerplate.
- Each sprint should leave behind app-facing scaffolding so the repository remains close to a shippable app shape.

## Patterns Discovered

- Capability-based monetization gating should live in a shared billing module rather than being scattered through UI code.
- Local deck storage should remain deck-scoped, with canonical `cards.json`, `notes.json`, and `images/` paths.
- Shared Swift packages are a good fit for cross-platform Apple logic that must be reused by phone, iPad, and Mac surfaces.
- JSON should remain the canonical local store, with SwiftData treated as an index/cache layer where it helps the app experience.
- Local study content needs protection hooks early through atomic writes and Apple data-protection-ready storage abstractions.
- The identifier types need `Codable` conformance at the boundary type level or downstream model serialization will fail immediately.

## Action Items for Next Sprint

- [ ] Begin Sprint 2 by implementing the canonical deck and note JSON codecs, storage protection, and the app-facing persistence scaffold on top of the foundation modules.
- [ ] Script or document the working Windows Swift test command so validation remains repeatable.
- [ ] Decide whether generated Python bytecode should remain tracked in the repo or be ignored and removed in a cleanup pass.

## Notes

Sprint 1 achieved its architectural purpose and its package-level validation target: the product now has a concrete system architecture, domain model, backlog sequencing, environment/testing guidance, initial app/module scaffolding, and passing Swift package tests on Windows. The remaining platform-validation gap is Apple runtime testing on macOS, not a missing Sprint 1 deliverable.
