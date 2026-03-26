"""
Project creation and initialization.

Handles creation of new Codex projects with sprint workflow system.
"""

import json
import shutil
from pathlib import Path
from typing import Optional

from ..exceptions import FileOperationError, ValidationError
from ..utils.state import get_codex_home


def sync_directory(source_root: Path, target_root: Path) -> int:
    """Copy a directory tree into a target and return the copied file count."""
    if not source_root.exists():
        return 0

    copied = 0
    for src in source_root.rglob("*"):
        if not src.is_file():
            continue
        dest = target_root / src.relative_to(source_root)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dest)
        if dest.suffix in {".py", ".sh", ".ps1", ".cmd"}:
            dest.chmod(0o755)
        copied += 1
    return copied


def create_project(target_path: Optional[str] = None, dry_run: bool = False) -> dict:
    """
    Initialize a new project with the complete sprint workflow system.

    Supports dual-mode operation:
    - Maestro mode: If templates/project/ exists in target, copy from local templates
    - Normal mode: Copy from ~/.codex/templates/project/ (standard projects)
    """

    if target_path:
        target = Path(target_path).resolve()
    else:
        target = Path.cwd().resolve()

    if not target.exists():
        raise FileOperationError(f"Directory not found: {target}")

    if (target / ".codex" / "sprint-steps.json").exists():
        raise ValidationError(
            f"Project already initialized at {target}\n"
            f"Use project-update to sync changes instead."
        )

    maestro_mode = (target / "templates" / "project").exists()
    global_codex = get_codex_home()

    if maestro_mode:
        template_path = target / "templates" / "project"
        print("MAESTRO MODE: Initializing from local templates")
        print(f"  Source: {template_path}")
    else:
        template_path = global_codex / "templates" / "project"
        if not template_path.exists():
            raise FileOperationError(
                f"Global Codex Maestro templates not found at {template_path}\n"
                f"Run the installer first."
            )

    if dry_run:
        print(f"[DRY RUN] Would initialize project at: {target}")
        print("\nWould create structure:")
        print(f"  - commands/ (from {global_codex}/commands/)")
        print(f"  - scripts/ (from {global_codex}/scripts/)")
        print("  - .codex/")
        print("    - agents/ (global + template)")
        print("    - hooks/ (global + template)")
        print("    - settings.json")
        print("    - sprint-steps.json")
        print("    - WORKFLOW_VERSION")
        print("  - docs/sprints/")
        print("    - 0-backlog/")
        print("    - 1-todo/")
        print("    - 2-in-progress/")
        print("    - 3-done/")
        print("    - 4-blocked/")
        print("    - 5-aborted/")
        print("    - 6-archived/")
        print("    - registry.json")
        print("  - CODEX.md")
        print("  - .gitignore (updated)")
        return {"status": "dry-run", "target": str(target)}

    print("Creating directory structure...")
    dirs_to_create = [
        target / ".codex" / "agents",
        target / ".codex" / "hooks",
        target / "docs" / "sprints" / "0-backlog",
        target / "docs" / "sprints" / "1-todo",
        target / "docs" / "sprints" / "2-in-progress",
        target / "docs" / "sprints" / "3-done",
        target / "docs" / "sprints" / "4-blocked",
        target / "docs" / "sprints" / "5-aborted",
        target / "docs" / "sprints" / "6-archived",
    ]
    if not maestro_mode:
        dirs_to_create.extend([target / "commands", target / "scripts"])

    for dir_path in dirs_to_create:
        dir_path.mkdir(parents=True, exist_ok=True)
    print("[OK] Created directory structure")

    command_count = 0
    if not maestro_mode:
        print("Copying commands...")
        command_count = sync_directory(global_codex / "commands", target / "commands")
        print(f"[OK] Copied {command_count} command files")
    else:
        print("[OK] Skipping commands/ (maestro mode - already exists)")

    if not maestro_mode:
        print("Copying scripts...")
        sync_directory(global_codex / "scripts", target / "scripts")
        print("[OK] Copied automation scripts")
    else:
        print("[OK] Skipping scripts/ (maestro mode - already exists)")

    print("Copying agents...")
    agent_count = 0
    if (global_codex / "agents").exists():
        for agent_file in (global_codex / "agents").glob("*.md"):
            shutil.copy2(agent_file, target / ".codex" / "agents" / agent_file.name)
            agent_count += 1
    if (template_path / ".codex" / "agents").exists():
        for agent_file in (template_path / ".codex" / "agents").glob("*.md"):
            shutil.copy2(agent_file, target / ".codex" / "agents" / agent_file.name)
            agent_count += 1
    print(f"[OK] Copied {agent_count} agents")

    print("Copying hooks...")
    hook_count = 0
    if (global_codex / "hooks").exists():
        for hook_file in (global_codex / "hooks").glob("*.py"):
            dest = target / ".codex" / "hooks" / hook_file.name
            shutil.copy2(hook_file, dest)
            dest.chmod(0o755)
            hook_count += 1
    if (template_path / ".codex" / "hooks").exists():
        for hook_file in (template_path / ".codex" / "hooks").glob("*.py"):
            dest = target / ".codex" / "hooks" / hook_file.name
            shutil.copy2(hook_file, dest)
            dest.chmod(0o755)
            hook_count += 1
    print(f"[OK] Copied {hook_count} hooks")

    print("Copying configuration...")
    if (template_path / ".codex" / "sprint-steps.json").exists():
        shutil.copy2(
            template_path / ".codex" / "sprint-steps.json",
            target / ".codex" / "sprint-steps.json",
        )
    if (template_path / ".codex" / "settings.json").exists():
        shutil.copy2(
            template_path / ".codex" / "settings.json",
            target / ".codex" / "settings.json",
        )
    if (global_codex / "WORKFLOW_VERSION").exists():
        shutil.copy2(
            global_codex / "WORKFLOW_VERSION", target / ".codex" / "WORKFLOW_VERSION"
        )
    print("[OK] Copied configuration files")

    print("Copying CODEX.md...")
    if not (target / "CODEX.md").exists():
        if (template_path / "CODEX.md").exists():
            shutil.copy2(template_path / "CODEX.md", target / "CODEX.md")
            print("[OK] Created CODEX.md")
        else:
            print("[WARN] Template CODEX.md not found, skipping")
    else:
        print("[OK] CODEX.md already exists, skipping")

    print("Creating sprint registry...")
    registry = {
        "counters": {"next_sprint": 1, "next_epic": 1},
        "sprints": {},
        "epics": {},
    }
    registry_path = target / "docs" / "sprints" / "registry.json"
    with open(registry_path, "w") as f:
        json.dump(registry, f, indent=2)
    print("[OK] Created sprint registry")

    print("Updating .gitignore...")
    gitignore_path = target / ".gitignore"
    gitignore_entries = [
        "# Sprint workflow state files",
        ".codex/sprint-*-state.json",
        ".codex/product-state.json",
    ]
    if gitignore_path.exists():
        content = gitignore_path.read_text()
        if "sprint-.*-state.json" not in content:
            with open(gitignore_path, "a") as f:
                f.write("\n")
                f.write("\n".join(gitignore_entries))
                f.write("\n")
            print("[OK] Updated .gitignore")
        else:
            print("[OK] .gitignore already configured")
    else:
        with open(gitignore_path, "w") as f:
            f.write("\n".join(gitignore_entries))
            f.write("\n")
        print("[OK] Created .gitignore")

    workflow_version = "unknown"
    if (target / ".codex" / "WORKFLOW_VERSION").exists():
        workflow_version = (target / ".codex" / "WORKFLOW_VERSION").read_text().strip()

    print(f"\n{'=' * 70}")
    if maestro_mode:
        print(f"[OK] Maestro workflow initialized at: {target}")
        print(f"{'=' * 70}")
        print("\nMAESTRO MODE - Dogfooding the workflow")
        print("  Source: ./templates/project/")
    else:
        print(f"[OK] Project workflow initialized at: {target}")
        print(f"{'=' * 70}")

    print("\nCreated structure:")
    if not maestro_mode:
        print(f"- commands/ ({command_count} command files)")
        print("- scripts/ (automation)")
    print("- .codex/")
    print(f"  - agents/ ({agent_count} agents)")
    print(f"  - hooks/ ({hook_count} hooks)")
    print("  - settings.json")
    print("  - sprint-steps.json")
    print("  - WORKFLOW_VERSION")
    print("- docs/sprints/")
    print("  - 0-backlog/")
    print("  - 1-todo/")
    print("  - 2-in-progress/")
    print("  - 3-done/")
    print("  - 4-blocked/")
    print("  - 5-aborted/")
    print("  - 6-archived/")
    print("  - registry.json")
    print("- CODEX.md")

    print("\nNext steps:")
    if maestro_mode:
        print("1. Use sprints to develop maestro itself (dogfooding)")
        print(
            '2. Create sprint: python ~/.codex/scripts/sprint_lifecycle.py register-sprint "Feature Name"'
        )
        print("3. Start working: sprint-start N")
        print("4. Publish templates with your preferred Codex workflow")
    else:
        print("1. Review and customize CODEX.md for your project")
        print(
            '2. Create your first sprint: python ~/.codex/scripts/sprint_lifecycle.py register-sprint "Initial Setup"'
        )
        print("3. Start working: sprint-start 1")

    print("\nTo sync future updates: project-update")
    print(f"Workflow version: {workflow_version}")
    print(f"{'=' * 70}")

    return {
        "status": "initialized",
        "target": str(target),
        "maestro_mode": maestro_mode,
        "command_count": command_count,
        "agent_count": agent_count,
        "hook_count": hook_count,
        "workflow_version": workflow_version,
    }
