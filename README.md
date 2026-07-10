# ithaca-ecology

**A context-first, ritual-based computing ecology for knowledge workers.**

Ithaca is a filesystem structure built in Linux that combines principles of Contextual Integrity (Nissenbaum) with adventure game conventions. It gives structure to how you work, where things live, and how an AI collaborator like Claude Code orients itself within your environment so that you do not have to rely on a single-loaded chat session to hold everything together.

[**Watch the lightning talk**](https://drive.google.com/file/d/1ptLeZKH-uczsZZVZpRc-wOxfyQdoxnzH/view?usp=drive_link) *(7 min, OpenMined Retreat, April 2026)*

---

## The Problem

When you limit AI agent use to a single chat thread whose backend you do not control, you hit a ceiling. You load it with context. It starts to fixate, misses the mark, and loops. More context in these cases doesn't help and often makes it worse.

In these cases the issue isn't the prompt. It's that there's no clear brief between you and the agent. The agent is operating under boundaries that you cannot see or control. Boundaries that can lead to no tangible sense of defined scope, role, or orientation.

Ithaca addresses aims to move AI agent interactions one-level up; at the brief-level, before users interact at the prompt-level.

---

## What Ithaca Is

Ithaca treats the filesystem as a series of **spheres of context** (Nissenbaum) — distinct places where different kinds of work happen, each with its own role, norms, and expectations. Folders are not storage containers; they are places.

The system has three interlocking layers:

**1. Sphere architecture** — Three parent directories (Academy, Town, Woodlands) plus a Bag for cross-sphere tools. Each sphere has its own mode of activity, its own values, and its own NPC characters that Claude can inhabit.

**2. The CLAUDE.md briefing layer** — Every sphere has a `CLAUDE.md` file that orients Claude Code to that sphere's role and norms before it acts. Claude is *context-dumb at the global level by design* — it must read the brief before it can work.

**3. Shell rituals** — Two bash files extend the shell with named navigation commands and creation rituals. Moving to a space is accompanied by a contextual prompt. Creating a thread, experiment, or commission is a named act, not just a `mkdir`.

The result: by giving the agent boundaries, you become more free. Orientation requires defining edges, this system allows you to play with defining worlds and contexts as opposed to defining a single input output chat.

---

## What's in This Repo

```
docs/           Concept documentation — read these to understand the system
talk/           Lightning talk materials (slides PDF + speaker notes)
template/       Everything you need to install Ithaca on your own machine
  shell/        arcane.sh, utils.sh, and what to add to ~/.bashrc
  claude/       Global CLAUDE.md (templatized)
  spheres/      Full folder skeleton with CLAUDE.md files for each sphere
    academy/
    town/
    woodlands/
    bag/         Includes the 24 file creation templates and spellbooks
```

Start with [`docs/concept.md`](docs/concept.md) for the full picture, or [`talk/speaker-notes.md`](talk/speaker-notes.md) for the narrative version.

---

## Quickstart

> You'll need: bash, Claude Code, a text editor. Everything else is optional.

**1. Copy the sphere folders into your home directory**

```bash
cp -r template/spheres/academy ~/sp_academy
cp -r template/spheres/town ~/sp_town
cp -r template/spheres/woodlands ~/sp_woodlands
cp -r template/spheres/bag ~/bag
```

**2. Install the shell layer**

```bash
mkdir -p ~/.ithaca/shell
cp template/shell/arcane.sh ~/.ithaca/shell/
cp template/shell/utils.sh ~/.ithaca/shell/
```

Then add the contents of `template/shell/bashrc-additions.sh` to your `~/.bashrc` and reload:

```bash
source ~/.bashrc
```

**3. Install the global Claude config**

```bash
cp template/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

**4. Personalize**

- Each `CLAUDE.md` has a `<!-- PERSONALIZE -->` block at the top listing what to change
- The most important customizations: your role names, your NPC names, and your research or work focus
- Read [`docs/customization-guide.md`](docs/customization-guide.md) for a full walkthrough

**5. Try the welcome ritual**

```bash
invoke
```

---

## Core Concepts

| Term | What it means |
|------|---------------|
| **Sphere** | A parent directory that is a distinct context — role, norms, values, NPCs |
| **CLAUDE.md** | The briefing file Claude reads on arrival to a sphere before acting |
| **NPC** | A named character Claude inhabits — each embodies a different epistemic stance |
| **Memory file** | A markdown file in `.memory/` that Claude reads on arrival and updates on departure |
| **Ritual** | A named shell command that creates a file structure and prompts a mode of work |
| **invoke** | The welcome command — prints the current sphere map, season, moon phase, and solar phase |

---

## Spheres at a Glance

| Sphere | Role | Entity | Mode |
|--------|------|--------|------|
| `academy/` | Scholar | The Lunar Society | Research, sense-making, making |
| `town/` | Adventurer | The Guild | Public-facing work, relationships, commerce |
| `woodlands/` | Witch | The Coven | Spiritual practice, wellbeing, seasonal attunement |
| `bag/` | Self | Self | Cross-sphere tools, daily journal |

These are the defaults in Ithaca. They can be renamed and reshaped for your own life — see [`docs/customization-guide.md`](docs/customization-guide.md).

---

## Inspiration and Theory

The sphere system is grounded in Helen Nissenbaum's theory of **Contextual Integrity** — the idea that information flows appropriately when they match the norms of the context in which they originate. Ithaca applies this to local computing: your filesystem encodes norms, and the AI reads those norms before acting.

The adventure game framing is literal. The user is not a player navigating the system — they are the Dungeon Master. The architect of the world, not a character within it.

---

## License

Shell scripts (`template/shell/`): [MIT License](LICENSE-MIT)

Documentation and templates: [CC BY 4.0](LICENSE-CC)

---

## About

Designed and built by [Kyoko Eng](https://github.com/Kiaka007) as an experiment in brief-level human-AI interaction. Presented at OpenMined Retreat, April 2026.
