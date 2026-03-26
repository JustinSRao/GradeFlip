---
description: "Initialize a new project with the sprint workflow system (dual-mode)"
allowed-tools: [Bash]
---

# Create Project Workflow

Run the create-project automation command:

```bash
python3 ~/.codex/scripts/sprint_lifecycle.py create-project $ARGUMENTS
```

## Dual-Mode Operation

This command automatically detects whether you're initializing:
- **Maestro mode**: When `templates/project/` exists (maestro repository itself)
- **Normal mode**: Standard projects using the workflow

### Maestro Mode

When running in codex-maestro repository:
- Copies FROM `./templates/project/` TO `./.codex/`
- Skips commands/ and scripts/ (already exist)
- Enables "dogfooding" - develop maestro using its own workflow
- Use `/maestro-publish` to export tested changes to other projects

### Normal Mode

When running in a regular project:
- Copies FROM `~/.codex/templates/project/` TO `./.codex/`
- Uses central commands and scripts from `~/.codex/`
- Standard project setup

**Usage:**
```
/project-create [target-path]
```

**Examples:**
```
/project-create                    # Initialize current directory
/project-create /path/to/project   # Initialize specific directory
/project-create --dry-run          # Preview changes
```

## What Gets Copied

### Normal Mode

| Component | Source | Destination |
|-----------|--------|-------------|
| Commands | `~/.codex/commands/` | Used centrally (not copied) |
| Scripts | `~/.codex/scripts/` | Used centrally (not copied) |
| Global Agents | `~/.codex/agents/` | `.codex/agents/` |
| Project Agents | `~/.codex/templates/project/.codex/agents/` | `.codex/agents/` |
| Global Hooks | `~/.codex/hooks/` | `.codex/hooks/` |
| Project Hooks | `~/.codex/templates/project/.codex/hooks/` | `.codex/hooks/` |
| Workflow Config | `~/.codex/templates/project/.codex/` | `.codex/` |
| CODEX.md | `~/.codex/templates/project/CODEX.md` | `./CODEX.md` |
| Sprint Dirs | Created automatically | `./docs/sprints/` |

### Maestro Mode

| Component | Source | Destination |
|-----------|--------|-------------|
| Project Agents | `./templates/project/.codex/agents/` | `.codex/agents/` |
| Project Hooks | `./templates/project/.codex/hooks/` | `.codex/hooks/` |
| Workflow Config | `./templates/project/.codex/` | `.codex/` |
| CODEX.md | `./templates/project/CODEX.md` | `./CODEX.md` |
| Sprint Dirs | Created automatically | `./docs/sprints/` |

**Prerequisites:**
- Target directory must exist
- **Normal mode**: Maestro installed globally (run `./install.sh` from codex-maestro repo)
- **Maestro mode**: `templates/project/` directory exists

**Next Steps After Creation:**

**Normal Mode:**
1. Review and customize CODEX.md for your project
2. Create your first sprint: `/sprint-new "Initial Setup"`
3. Start working: `/sprint-start 1`

**Maestro Mode:**
1. Use sprints to develop maestro itself (dogfooding)
2. Create sprint: `/sprint-new "Feature Name"`
3. Start working: `/sprint-start N`
4. Publish templates: `/maestro-publish` (when ready)
