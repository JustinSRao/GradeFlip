---
description: "Sync workflow updates from master environment to project"
allowed-tools: [Read, Write, Bash, Glob]
---

# Update Project Workflow

Sync workflow updates from the master environment to the current project.

## What Gets Synced

| Component | Source | Action |
|-----------|--------|--------|
| Commands | `~/.codex/commands/` | Central (run `install.sh` to update) |
| Scripts | `~/.codex/scripts/` | Central (run `install.sh` to update) |
| Agents | `~/.codex/agents/` + `~/.codex/templates/project/.codex/agents/` | Add/Update |
| Hooks | `~/.codex/hooks/` + `~/.codex/templates/project/.codex/hooks/` | Add/Update |
| sprint-steps.json | `~/.codex/templates/project/.codex/sprint-steps.json` | Update |
| WORKFLOW_VERSION | `~/.codex/WORKFLOW_VERSION` | Update |
| CODEX.md | `~/.codex/templates/project/CODEX.md` | **Skip** (user customized) |
| settings.json | - | **Skip** (project specific) |
| State files | - | **Skip** (runtime data) |

**Note:** Commands and scripts are now central. To update them, run `./install.sh` in the codex-maestro repo.

## Instructions

### 1. Determine Target Project

```bash
TARGET_PATH="${ARGUMENTS:-$(pwd)}"
echo "Updating project at: $TARGET_PATH"
```

### 2. Validate Project

```bash
# Check project is initialized
if [ ! -f "$TARGET_PATH/.codex/sprint-steps.json" ]; then
  echo "ERROR: Project not initialized. Run /project-create first."
  exit 1
fi

# Show current version
echo "Current workflow version: $(cat $TARGET_PATH/.codex/WORKFLOW_VERSION 2>/dev/null || echo 'unknown')"
echo "Master workflow version: $(cat ~/.codex/WORKFLOW_VERSION 2>/dev/null || echo 'unknown')"
```

### 3. Create Backup

```bash
BACKUP_DIR="$TARGET_PATH/.codex/.backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup current files
cp -r "$TARGET_PATH/.codex/agents" "$BACKUP_DIR/" 2>/dev/null || true
cp -r "$TARGET_PATH/.codex/hooks" "$BACKUP_DIR/" 2>/dev/null || true
cp "$TARGET_PATH/.codex/sprint-steps.json" "$BACKUP_DIR/" 2>/dev/null || true

echo "Backup created at: $BACKUP_DIR"
```

### 4. Check Central Installation

```bash
echo ""
echo "=== Checking Central Installation ==="

MAESTRO_HOME="$HOME/.codex"

# Check if Maestro is properly installed
if [ ! -d "$MAESTRO_HOME/scripts" ]; then
  echo "WARNING: Scripts not found at $MAESTRO_HOME/scripts"
  echo "Run ./install.sh in the codex-maestro repo to update"
else
  echo "✓ Central scripts: $MAESTRO_HOME/scripts"
fi

if [ ! -d "$MAESTRO_HOME/commands" ]; then
  echo "WARNING: Commands not found at $MAESTRO_HOME/commands"
  echo "Run ./install.sh in the codex-maestro repo to update"
else
  echo "✓ Central commands: $MAESTRO_HOME/commands"
fi
```

### 5. Sync Agents

Track changes:
- ADDED: New agents not in project
- UPDATED: Changed agents
- UNCHANGED: Identical agents

```bash
echo ""
echo "=== Syncing Agents ==="

AGENTS_ADDED=0
AGENTS_UPDATED=0
AGENTS_UNCHANGED=0

# Sync from global agents
for agent in ~/.codex/agents/*.md; do
  [ -f "$agent" ] || continue
  filename=$(basename "$agent")
  target="$TARGET_PATH/.codex/agents/$filename"

  if [ ! -f "$target" ]; then
    cp "$agent" "$target"
    echo "  Added: $filename"
    ((AGENTS_ADDED++))
  elif ! diff -q "$agent" "$target" > /dev/null 2>&1; then
    cp "$agent" "$target"
    echo "  Updated: $filename"
    ((AGENTS_UPDATED++))
  else
    ((AGENTS_UNCHANGED++))
  fi
done

# Sync from template agents
for agent in ~/.codex/templates/project/.codex/agents/*.md; do
  [ -f "$agent" ] || continue
  filename=$(basename "$agent")
  target="$TARGET_PATH/.codex/agents/$filename"

  if [ ! -f "$target" ]; then
    cp "$agent" "$target"
    echo "  Added: $filename"
    ((AGENTS_ADDED++))
  elif ! diff -q "$agent" "$target" > /dev/null 2>&1; then
    cp "$agent" "$target"
    echo "  Updated: $filename"
    ((AGENTS_UPDATED++))
  else
    ((AGENTS_UNCHANGED++))
  fi
done

echo "Agents: $AGENTS_ADDED added, $AGENTS_UPDATED updated, $AGENTS_UNCHANGED unchanged"
```

### 6. Sync Hooks

```bash
echo ""
echo "=== Syncing Hooks ==="

HOOKS_ADDED=0
HOOKS_UPDATED=0
HOOKS_UNCHANGED=0

# Sync from global hooks
for hook in ~/.codex/hooks/*.py; do
  [ -f "$hook" ] || continue
  filename=$(basename "$hook")
  target="$TARGET_PATH/.codex/hooks/$filename"

  if [ ! -f "$target" ]; then
    cp "$hook" "$target"
    echo "  Added: $filename"
    ((HOOKS_ADDED++))
  elif ! diff -q "$hook" "$target" > /dev/null 2>&1; then
    cp "$hook" "$target"
    echo "  Updated: $filename"
    ((HOOKS_UPDATED++))
  else
    ((HOOKS_UNCHANGED++))
  fi
done

# Sync from template hooks
for hook in ~/.codex/templates/project/.codex/hooks/*.py; do
  [ -f "$hook" ] || continue
  filename=$(basename "$hook")
  target="$TARGET_PATH/.codex/hooks/$filename"

  if [ ! -f "$target" ]; then
    cp "$hook" "$target"
    echo "  Added: $filename"
    ((HOOKS_ADDED++))
  elif ! diff -q "$hook" "$target" > /dev/null 2>&1; then
    cp "$hook" "$target"
    echo "  Updated: $filename"
    ((HOOKS_UPDATED++))
  else
    ((HOOKS_UNCHANGED++))
  fi
done

echo "Hooks: $HOOKS_ADDED added, $HOOKS_UPDATED updated, $HOOKS_UNCHANGED unchanged"
```

### 7. Sync Configuration

```bash
echo ""
echo "=== Syncing Configuration ==="

# Update sprint-steps.json
if [ -f ~/.codex/templates/project/.codex/sprint-steps.json ]; then
  if ! diff -q ~/.codex/templates/project/.codex/sprint-steps.json "$TARGET_PATH/.codex/sprint-steps.json" > /dev/null 2>&1; then
    cp ~/.codex/templates/project/.codex/sprint-steps.json "$TARGET_PATH/.codex/"
    echo "  Updated: sprint-steps.json"
  else
    echo "  Unchanged: sprint-steps.json"
  fi
fi

# Update workflow version
if [ -f ~/.codex/WORKFLOW_VERSION ]; then
  cp ~/.codex/WORKFLOW_VERSION "$TARGET_PATH/.codex/"
  echo "  Updated: WORKFLOW_VERSION"
fi
```

### 8. Report Preserved Files

```bash
echo ""
echo "=== Preserved (not overwritten) ==="
echo "  - .codex/settings.json (project configuration)"
echo "  - .codex/sprint-*-state.json (runtime state)"
echo "  - .codex/product-state.json (runtime state)"
echo "  - CODEX.md (user customized)"
```

### 9. Report Summary

```
✅ Project workflow updated: $TARGET_PATH

Summary:
  Commands/Scripts: Central (~/.codex/) - run install.sh to update
  Agents: $AGENTS_ADDED added, $AGENTS_UPDATED updated
  Hooks: $HOOKS_ADDED added, $HOOKS_UPDATED updated
  Config: sprint-steps.json, WORKFLOW_VERSION

Backup: $BACKUP_DIR

New workflow version: $(cat ~/.codex/WORKFLOW_VERSION 2>/dev/null || echo 'unknown')

Note: Review updated hooks for any breaking changes.
To restore: cp -r $BACKUP_DIR/* $TARGET_PATH/.codex/
```

## Flags

- `--dry-run` - Show what would change without applying
- `--force-claude-md` - Also update CODEX.md (overwrites customizations)
- `--no-backup` - Skip creating backup

## Examples

```bash
# Update current project
/project-update

# Update specific project
/project-update /path/to/project

# Preview changes
/project-update --dry-run

# Force update CODEX.md too
/project-update --force-claude-md
```
