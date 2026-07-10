# sp_academy/labs — The Labs

## Mode: Labs

**Prompt:** What happens if?

This is a space for ephemeral exploration and play. Nothing here is precious. Experiments live and die freely. The goal is to *see*, not to prove.

## Structure

- **experiments/** — Notebooks and sketches. Primarily holds Jupyter notebooks and scripts that experiment with computation logic. Answers: "What are you trying to see today?"
- **src/** — Code that survives. When something proves valuable, it migrates here.
- **data/** — Materials for input. Raw and processed datasets for experiments.

## Conventions

**Experiments are dated:** `YYYY-MM-topic-notes.md` (created via `expx <topic>`)

**Jupyter notebooks live in experiments/** — Open with `labx` (activates conda jupyter env)

**No cleanup obligation.** Failed experiments can remain indefinitely or be deleted without ceremony. Natural neglect is acceptable.

**Migration, not promotion.** When code proves useful:
- Reusable code → `labs/src/`
- Emerging concept → `library/notes/threads/`
- Committed deliverable → `workshop/commissions/`

## Shell Commands

| Command | Effect |
|---------|--------|
| `labs` | Go to labs root |
| `exp` | Go to experiments/ |
| `labsrc` | Go to src/ |
| `data` | Go to data/ |
| `expx <topic>` | Create new experiment with dated slug |
| `labx` | Open Jupyter Lab in experiments/ |

## Working Here

- Favor exploration over completeness
- Notebooks can be messy; they're thinking tools
- Name files for discoverability, not permanence
- If something feels like it wants structure, it may belong elsewhere
