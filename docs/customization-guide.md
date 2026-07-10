# Customization Guide

Ithaca ships with a specific set of sphere names, roles, entities, and NPCs — those that made sense for one researcher's life. This guide explains how to adapt every layer of the system to your own.

The core architecture (spheres, CLAUDE.md files, shell rituals, memory structure) stays the same. Only the vocabulary changes.

---

## What You Should Personalize

Each `CLAUDE.md` in the template has a `<!-- PERSONALIZE -->` block at the top listing the fields that are specific to the original Ithaca. Everything else can be left as-is to start.

The most meaningful changes are:

1. **Sphere names and roles** — What are the major contexts of your life?
2. **Entity names** — What imaginary community or collective does each sphere serve?
3. **NPCs** — What kinds of conversations do you want to have with what type of characters?
4. **Temporal prompts** — What phrases do you want to see during each season, moon phase, or solar phase?

---

## Renaming Spheres

Ithaca's three spheres — Academy, Town, Woodlands — reflect one person's life. You might name yours differently:

| Original | Alternative examples |
|----------|---------------------|
| `sp_academy/` | `studio/`, `lab/`, `workshop/`, `atelier/` |
| `sp_town/` | `market/`, `social/`, `agora/`, `commons/` |
| `sp_woodlands/` | `garden/`, `practice/`, `grove/`, `inner/` |

To rename a sphere:

1. Rename the folder (e.g. `mv sp_academy studio`)
2. Update the `export` line in `~/.bashrc` (e.g. `export ACADEMY="$HOME/studio"`)
3. Update the sphere name and role inside the CLAUDE.md at the sphere root
4. Update the global `~/.claude/CLAUDE.md` to list your new sphere names

The internal structure of each sphere (labs, library, workshop, etc.) can stay the same or be renamed to match your vocabulary.

---

## Defining Your Own Roles and Entities

Each sphere's CLAUDE.md has a role and an entity. These establish the register of work in that space.

**Role** — who you are when you're there. It sets the tone for how Claude addresses you and what kind of work it assumes you're doing.

Examples:
- Researcher → Practitioner → Maker → Steward → Editor → Strategist

**Entity** — the imaginary body this sphere serves. It gives the work a sense of accountability and audience, even when you're working alone.

Examples:
- The Lunar Society (original) → The Studio Collective → The Reading Room → The Commons → The Archive

In the CLAUDE.md, this looks like:

```markdown
**Your role here:** Scholar
**Entity served:** The Lunar Society
```

Change both to match how you think about each area of your life.

---

## Creating Your Own NPCs

NPCs are the most personal layer of the system. Each NPC embodies an epistemic stance — a way of thinking — that you want to be able to call on deliberately.

To define an NPC, answer these questions:
- What is their name?
- What do they prioritize when they respond?
- What is their characteristic move? (e.g. The Scribe asks "what is this related to?")
- What sphere do they belong to?

Example NPC definition (from a sphere CLAUDE.md):

```markdown
### NPC: The Editor
Role: Clarifying — removes what doesn't serve the argument
Characteristic move: "What would you cut first?"
Memory file: `.memory/editor-sessions.md`
```

You can have multiple NPCs per sphere. The key is that each one should feel different to talk to — a different mode of attention, not just a different name.

Faculty advisors (like the original Ithaca's advisor-a and advisor-b) are a specific pattern: one generative, one critical. If you do research or writing, this pairing is worth keeping. Just give them names that feel real to you.

---

## Adapting the Temporal System

`utils.sh` contains the seasonal, lunar, and solar layers. All three can be customized:

**Wheel of Year phrases** — Each of the 8 sabbats has a phrase that prints during `invoke`. Find them in `utils.sh` under `get_sabbat_season()`. Replace with your own seasonal language or remove the section entirely if it doesn't resonate.

**Moon phase phrases** — Similarly customizable in `get_moon_phase()`. Or swap for a different lunar system.

**Solar phase names** — The names for times of day (Deep Night, Early Morning, etc.) are in `get_solar_phase()`. These can be renamed or replaced.

**Northern vs. Southern Hemisphere** — `utils.sh` currently calculates sabbat seasons for the Northern Hemisphere. For Southern Hemisphere, the sabbat dates are offset by ~6 months. A comment in the file marks where to adjust.

---

## Adding or Removing Spheres

The system works with any number of spheres. Two is enough. Just try to keep in mind what a reasonable maximum is before the cognitive load of switching contexts exceeds the benefit.

To add a sphere:
1. Create the folder at your home directory root
2. Add a CLAUDE.md using the sphere template
3. Create a `.memory/` directory with a `MEMORY.md` index
4. Add a navigation function to `arcane.sh`
5. Add the export to `~/.bashrc`
6. Add it to the global `~/.claude/CLAUDE.md` sphere listing

To remove a sphere, reverse those steps — and consider whether its work should migrate into one of the remaining spheres.

---

## The Bag

The Bag doesn't need to be called `bag/`. But whatever you call it, it can be useful to keep a cross-sphere space: somewhere for tools, templates, and daily journal entries that don't belong to any single sphere. It's the thing you carry between places. Just make sure nothing too context heavy within the bag burdens your journey. If the bag begins to be the primary place that you store context then consider whether you need to new sphere.

---

## What Not to Change

The structural principles are the system. These are worth keeping even as everything else changes:

- **Global CLAUDE.md says Claude is context-dumb** — This is the rule that makes the whole system work. Keep it.
- **Each sphere has a CLAUDE.md** — This is what makes spheres meaningful to Claude, not just to you.
- **Memory lives in `.memory/`** — Sphere-local memory prevents context bleed between spheres.
- **Creation rituals have names** — `threadx`, `expx`, `prjx` aren't just shortcuts; they signal a mode of work. When customizing or creating new bash commands try to keep them grounded in what mode of thinking and where in the filesystem they affect.
- **Orientation** — The design principle holding this system together is the idea of orientation. Try to avoid creating bash or other commands that switch between spheres without telling you. If you can't pinpoint where something is being stored then it may be a flag that too much automation or context switching is happening.
