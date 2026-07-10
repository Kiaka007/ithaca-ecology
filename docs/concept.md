# Ithaca: OS Details and Concept

*Date: 2026-04-10*

---

## What This Is

**Ithaca** is an OS information ecology that combines principles of Contextual Integrity with adventure game conventions. Unlike conventional operating environments, Ithaca was built as a **context-first, ritual-based computing ecology** — meaning that the physical structure of the filesystem carries meaning, work has modes rather than just tasks, and that all commands support orientation over automation.

In short: it gameifies the filesystem and how Claude Code interacts within it.

---

## The Central Concept: Spheres

Instead of folders being a place for storage, this system treats them as individual places — **spheres of context** *(Helen Nissenbaum, Contextual Integrity)*. Each sphere is a distinct place with:

- A **role** the user inhabits there
- An imaginary **entity** the sphere serves (a community, a collective, a tradition)
- A **set of norms** for what activities happen within that sphere
- A **set of values** for *how* those activities take place
- A list of **NPC** character definitions — the personas Claude may inhabit while in that sphere

| Sphere       | Role       | Entity            | Norm Focus                                              | Values                                      | NPCs                          |
| ------------ | ---------- | ----------------- | ------------------------------------------------------- | ------------------------------------------- | ----------------------------- |
| `academy/`   | Scholar    | The Lunar Society | Research, sense-making, making                          | Prefer slow synthesis over fast conclusions | The Scholar, Faculty Advisors |
| `town/`      | Adventurer | The Guild         | Public-facing work, relationships, commerce             | Prioritize connection over expansion        | The Tavern Keeper             |
| `woodlands/` | Witch      | The Coven         | Spiritual practice, wellbeing, seasonal attunement      | Observe before acting. Seek balance.        | The Oracle                    |
| `bag/`       | Self       | Self              | Cross-sphere tools and daily journal                    | —                                           | —                             |

**Note:** The placement of a file is an act of categorization. Putting something in `town/market/` rather than `academy/library/drafts/` is a decision about whether something is ready to go public, not just a folder choice.

---

## Design Primitives

Five principles underpin every design decision in this ecology:

**1. Context before action.**
Establish orientation before making changes. The sphere system, CLAUDE.md files, and arrival rituals all embody this. Knowing where you are comes before knowing what to do.

**2. Modes over tasks.**
Work is a state of being, not a task list. The spaces have names for what happens in them: Explore, Think, Make, Attune. The right question is "what mode am I in?" not "what is on my list?"

**3. Transparency over abstraction.**
Nothing important should be hidden. Shell commands read as documentation of intent. The file system is legible. CLAUDE.md files are plain text anyone can read and edit.

**4. Remember gently.**
The system holds context so the human doesn't have to. Journals, thread handoffs, NPC memory files, and the quest log all exist to reduce the cognitive cost of returning to work after time away. No judgment for forgetting — the structure carries it.

**5. Longevity over optimization.**
Plain text. Minimal dependencies. The system should still make sense in five years. Features are only added when they serve a clear purpose in the ecology; automation is not valued for its own sake.

---

## The Academy in Detail

The Academy is the sphere where research and knowledge work lives. It has three main spaces:

| Space       | Mode    | What Happens There                                      |
| ----------- | ------- | ------------------------------------------------------- |
| `labs/`     | Explore | Ephemeral experiments. Nothing is precious.             |
| `library/`  | Think   | Sense-making across time. Understanding emerges slowly. |
| `workshop/` | Make    | Bounded work with deliverables. Obligation lives here.  |

The library is the richest space. It contains:

- `notes/` — Raw thinking: field notes, research synthesis, threads, methods, readings
- `tomes/` — Generative idea wells: reservoirs for thoughts that haven't resolved into direction yet
- `drafts/` — Rehearsal space: papers, talks, applications — things intended to be shared
- `archive/` — Retired work: complete or abandoned things preserved for memory

Work **moves through the Academy** along a defined trajectory: an observation might start in notes, crystallize into a thread, solidify into a draft, and finally archive. The structure makes these transitions visible and intentional.

---

## The Shell as Ecology

The shell is not just a command-line interface — it is the primary navigation and ritual layer of Ithaca. Two key files extend bash:

**`~/.ithaca/shell/arcane.sh`** — The Academy, Town, Woodlands, and Bag shell layer. Every space has a named function that navigates to it *and* provides context on arrival:

```bash
labs()     # → "⚗️ THE LAB — Exploration, play / Prompt: What happens if?"
tomes()    # → "💡 TOMES — Wells of generative thought"
drafts()   # → "📜 DRAFTS — Rehearsal space, nothing is final"
```

Creation rituals are named with intention:

```bash
expx <topic>    # Opens a new experiment with a notes template
threadx <name>  # Creates a thread with decisions/, handoffs/, feedback/, returns/ subdirs
prjx <name>     # Creates a commission with design/, research/, prototypes/, outputs/
tomex <name>    # Creates a new tome
fieldx <study>  # Creates a field study with pre/, raw/, post/ phases
```

Each name is a ritual in practice — it helps you enter a mode of thinking for the activity you're about to engage in.

**`~/.ithaca/shell/utils.sh`** — Shared helpers that ground the system in the time of day and the season.

- **Wheel of Year**: The system knows which sabbat season it is (Imbolc, Ostara, Beltane, etc.) based on date and returns a contextual phrase for that season. Currently based on Northern Hemisphere.
- **Moon phase**: Calculated locally via date arithmetic, returns a phase name and a reflection phrase.
- **Solar anchors**: Fetches actual sunrise, solar noon, and sunset times from an API (with local cache and graceful fallback), then uses them to name the current phase of day: Deep Night, Early Morning, Late Morning, Early Afternoon, Late Afternoon, Early Evening, Late Evening.

These temporal layers feed into the `invoke` command — the welcome ritual — which prints a map of Ithaca, the current season and its phrase, the moon phase, and the current solar phase. These prompts can be further customized in `arcane.sh`.

---

## The CLAUDE.md Layer: AI That Uses Bounded Context

This is where the ecology intersects directly with Claude Code. Every sphere has a `CLAUDE.md` file at its root. These files do not configure software — they orient AI agents to the sphere's role, norms, and expectations before the agent acts.

The global `~/.claude/CLAUDE.md` establishes one key rule: **Claude is context-dumb at the global level by design.** It does not arrive knowing what sphere it's in. It must read the sphere's CLAUDE.md first. This models the principle of *context before action* in the computing environment itself.

Each sphere's CLAUDE.md includes:

- The role the user plays there (Scholar, Adventurer, Witch, etc.)
- The tone and norms of that space
- The NPC characters Claude is able to inhabit when in that space, including a default role
- Relevant memory files to read on arrival and update on departure

### NPCs

Each sphere has one or more named NPCs. These are characters with personalities, individual memory, and defined skills — they help a user name what type of conversation they want to engage in. Ithaca ships with:

| Sphere             | NPC               | Character                                                                      |
| ------------------ | ----------------- | ------------------------------------------------------------------------------ |
| `academy/library/` | The Scribe        | Patient, connective — asks "what is this related to?"                          |
| `academy/` faculty | advisor-a (example) | Generative — opens, expands, prompts possibility                             |
| `academy/` faculty | advisor-b (example) | Critical — narrows, tests, finds what doesn't hold                           |
| `town/`            | The Tavern Keeper | Practical, well-connected — tracks readiness and relationships                 |
| `woodlands/`       | The Oracle        | Quiet, seasonal — notices and reflects back                                    |
| `bag/`             | The Messenger     | Quiet utility, finds what you need — no personality agenda                     |

NPCs are **invokable personas** — Claude adopts the character when working within that sphere. Each NPC embodies a different *epistemic stance*: generative vs. critical vs. observational vs. practical. Choosing which NPC to invoke is choosing what kind of thinking you need.

### Memory Architecture

Sphere-local memory lives in each sphere's `.memory/` directory. These are markdown files Claude reads on arrival and updates on departure — tracking relationship patterns, active threads, seasonal observations, tool inventories, and cross-sphere signals. Global memory lives in `~/.claude/projects/`.

This means Claude can hold context across sessions in structured records that stay in the right place, maintained by the appropriate NPC for each sphere.

---

## Tools and Integrations

Ithaca is designed to be tool-agnostic at its core. Kyoko's setup includes:

- **Neovim** — default editor, invoked by most creation rituals
- **Jupyter Lab** — for experiments in `labs/`, opened via `labx`
- **Taguette** — qualitative coding, database in `labs/data/`
- **Miniconda** — Python/Jupyter environment management

The system favors lightweight, local-first solutions. When possible it keeps information management local and avoids unnecessary dependencies.

---

## What Makes This Different

Most operating environments are optimized for output — they make it easy to produce things quickly. Ithaca is optimized for a different kind of user: one doing slow, meaning-dense work across multiple timescales, with an AI agent as a collaborator rather than an assistant.

Key differentiators:

- **The folder is a place, not a unit of storage.** Parent folders act as spheres of context — individual places with their own set of norms, roles, and values.
- **CLAUDE.md = the briefing protocol.** On a global level Claude is context-dumb. It reads the CLAUDE.md (the brief) of a sphere before acting within it.
- **NPCs = epistemic stances.** Choosing who to talk to is choosing what kind of thinking mode you want to enter (generative, critical, practical, conceptual, etc.).
- **Rituals over tasks.** Commands and spaces encourage entering modes of activity rather than completing a set list of tasks.
- **The reward system = reflection over optimization.** Reward currencies track what kinds of energy have been spent, not whether enough was done.
- **Temporal anchoring.** The season, moon, and solar phase are built into shell rituals — grounding daily computing within nature's cycles.
