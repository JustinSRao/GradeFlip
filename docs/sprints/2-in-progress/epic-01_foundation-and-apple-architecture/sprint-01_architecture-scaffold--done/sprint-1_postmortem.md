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
| Tests Added | 4 Swift test functions across 2 test files |
| Coverage Delta | N/A - Swift CLI could not run due missing `swift-driver.exe` in installed Windows toolchain |

## What Went Well

- The architecture boundary work was concrete enough to turn into real docs rather than vague notes.
- The repo now has a usable module layout and a root Swift package manifest instead of only workflow files.
- The backlog was normalized to Sprint 1 through Sprint 15 and now has complete specifications for each sprint and epic.
- The GitHub remote is now connected to a real local git repository.

## What Could Improve

- Shorter sprint folder/file slugs should have been chosen earlier to avoid Windows path-length failures in git.
- The Windows Swift toolchain should have been validated before relying on it for the sprint test step.
- Generated Python bytecode and other workflow bootstrap artifacts should be reviewed before the first implementation commit to keep the history cleaner.

## Blockers Encountered

- The initial workflow registration bug advanced sprint numbering to 16 through 30 before valid sprint files existed.
- Windows git path-length limits blocked the first implementation commit until sprint slugs were shortened.
- The installed Swift Windows toolchain is missing `swift-driver.exe`, causing Swift CLI commands to fail with exit code `0xC0000135`.
- The project was not initially a git repository, so git initialization and remote wiring had to be added during the sprint.

## Technical Insights

- GradeFlip benefits from a strict separation between offline core, subscription-backed online features, and AI token usage.
- Supabase with PostgreSQL is the better backend fit than MongoDB for the product's social, billing, and ledger-heavy shape.
- Stable IDs for decks, flashcards, notes, and image assets are essential because deck renames, image alignment, sharing, and AI deck selection all depend on them.
- Windows path limits can affect workflow-generated sprint file structures if slugs are too verbose.

## Process Insights

- The sprint workflow can move quickly once the backlog and numbering are corrected, but environment validation should happen before depending on test steps.
- Separating the implementation commit from the completion automation makes the close-out flow cleaner and easier to reason about.
- Postmortem generation is more useful when the template is filled immediately rather than left as boilerplate.

## Patterns Discovered

- Capability-based monetization gating should live in a shared billing module rather than being scattered through UI code.
- Local deck storage should remain deck-scoped, with canonical `cards.json`, `notes.json`, and `images/` paths.
- Shared Swift packages are a good fit for cross-platform Apple logic that must be reused by phone, iPad, and Mac surfaces.

## Action Items for Next Sprint

- [ ] Repair or replace the broken Windows Swift toolchain so `swift test` can run reliably.
- [ ] Begin Sprint 2 by implementing the canonical deck and note JSON codecs on top of the scaffolded modules.
- [ ] Decide whether generated Python bytecode should remain tracked in the repo or be ignored and removed in a cleanup pass.

## Notes

Sprint 1 achieved its main architectural purpose: the product now has a concrete system architecture, domain model, backlog sequencing, and real package/module scaffolding. The only incomplete validation item was automated Swift test execution, and that was blocked by the installed Windows Swift toolchain missing `swift-driver.exe` rather than by missing Sprint 1 implementation work.
