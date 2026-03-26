# Project Instructions

## Workflow System

This project uses an **AI-assisted development workflow** with parallel agents, skills, and lifecycle scripts.

**Workflow Version**: See `.codex/WORKFLOW_VERSION` for current version.

### Codex Note

This project template comes from `codex-maestro`, a Codex port of `claude-maestro`.

- The original workflow assumes Claude-native slash commands.
- In Codex, prefer installed wrappers when available.
- Fall back to the lifecycle scripts directly when wrappers are unavailable.
- Treat `commands/` as workflow reference docs, not as guaranteed native commands.

### Quick Start

```bash
sprint-new "Feature Name"
sprint-start <N>
sprint-next <N>
sprint-status <N>
sprint-complete <N>
```

Fallback:

```bash
python ~/.codex/scripts/sprint_lifecycle.py register-sprint "Feature Name"
python ~/.codex/scripts/sprint_lifecycle.py start-sprint <N>
python ~/.codex/scripts/sprint_lifecycle.py advance-step <N>
python ~/.codex/scripts/sprint_lifecycle.py sprint-status <N>
python ~/.codex/scripts/sprint_lifecycle.py complete-sprint <N>
python ~/.codex/scripts/sprint_lifecycle.py generate-postmortem <N>
```

### How It Works

```
Phase 1: Planning (sequential)
├── Read sprint → Plan agent designs team → Clarify requirements

Phase 2: Implementation (PARALLEL)
├── Backend agent ──┐
├── Frontend agent ─┼── Run simultaneously
└── Test agent ─────┘

Phase 3: Validation (sequential)
├── Integrate → Run tests → Quality review → User approval

Phase 4: Complete (sequential)
├── Commit → Move to done → Postmortem
```

### Key Concepts

- **Agents**: Plan, product-engineer, quality-engineer, test-runner, devops-engineer
- **State Files**: `.codex/sprint-N-state.json` tracks each sprint
- **Sprint Counter**: `docs/sprints/next-sprint.txt` auto-assigns numbers

### Sprint Directories

| Directory | Purpose |
|-----------|---------|
| `docs/sprints/1-todo/` | Planned sprints waiting to start |
| `docs/sprints/2-in-progress/` | Currently active sprints |
| `docs/sprints/3-done/` | Completed sprints |
| `docs/sprints/5-aborted/` | Cancelled/abandoned sprints |

### Workflow Enforcement

The sprint workflow is primarily enforced through lifecycle scripts. Hooks are preserved as reference material for future Codex-native enforcement. Key rules:
- Cannot skip steps - must complete current before advancing
- Cannot commit without completing sprint
- All sprints require postmortem before completion
- Sprint numbers auto-assigned from counter file
- Do not manually edit sprint state or registry files

### Epic Management

Group related sprints into epics:

```bash
python ~/.codex/scripts/sprint_lifecycle.py register-epic "Epic Name"
python ~/.codex/scripts/sprint_lifecycle.py start-epic <N>
python ~/.codex/scripts/sprint_lifecycle.py register-sprint "Feature" --epic N
python ~/.codex/scripts/sprint_lifecycle.py complete-epic <N>
```

---

## Project-Specific Instructions

<!-- Add your project-specific instructions below -->

### Code Standards

- Add your coding standards here

### Testing Requirements

- Add your testing requirements here

### Deployment

- Add your deployment process here
