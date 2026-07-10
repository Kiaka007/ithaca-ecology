# bag/tools — Tools

## Mode: Tools

This is a space for repeatable instruments. Scripts, templates, references, configurations. These serve the other spaces in the ecology.

## Structure

- **scripts/** — Repeatable code. Utilities, automation, things that run.
- **templates/** — Repeatable formats and frames. Starting points for new files.
- **spellbooks/** — References to commands, shortcuts, syntax. Documentation for recall.

## Conventions

**Templates are used by shell rituals:**
- `expx <topic>` uses `templates/experiments-base.md`
- `entry` uses `templates/entry.md`
- `tomex <name>` uses `templates/tome-base.md`

**Scripts should be readable as documentation.** The code explains the intent, not just the mechanics.

**Spellbooks are for recall, not learning.** Terse is fine — these are for someone who already understands but needs a reminder.

## Shell Commands

| Command | Effect |
|---------|--------|
| `tools` | Go to tools root |
| `scripts` | Go to scripts/ |
| `templates` | Go to templates/ |
| `spellbooks` | Go to spellbooks/ |

## Working Here

- Tools should be stable — other parts of the system depend on them
- When modifying a template, consider what rituals use it
- Prefer transparency: a script's purpose should be evident from reading it
- If a script becomes complex, it may deserve its own documentation in spellbooks/
