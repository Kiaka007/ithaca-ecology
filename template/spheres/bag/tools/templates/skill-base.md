---
name: <!--Slash command name-->
description: >
    Description of what the skill does and when the skill should auto-trigger.
argument-hint: "[timeframe]"
disable-model-invocation: <!--true= never auto-triggers, manual invoke only-->
user-invocable: <!--false = hidden from /menu (background run only)-->
allowed-tools: <!--Tools pre-approved for this skill, e.g. Bash, Read-->
model: <!--Override which claude model to use e.g. haiku, sonnet, opus-->
context: <!--fork = run in isolated subagent-->
agent: <!--Which agent type to use when forking (general-purpose | Explore | Plan | custom-name-->
---

# [Skill Name]

[One sentence describing what this skill does and when it belongs in the cycle.]

## Usage

- `/skill-name` — [default behavior]
- `/skill-name [timeframe]` — e.g. `7d`, `48h`, `season`
- `/skill-name [FILTER]` — e.g. a shelf, category, or scope filter
- `/skill-name [FILTER] [timeframe]` — combine filters; order should not matter

Remove usage variants that don't apply.

## Instructions

### Step 1: Parse Arguments and Establish Context

Parse `$ARGUMENTS` for optional filters. Define defaults for anything not provided.

Print the opening header:

```
[emoji] SKILL NAME

[Label]: [value or "default"]
[Label]: [value or "all"]
```

### Step 2: Gather [Source Data]

Describe what data this skill reads. Show the bash command used to find or extract it:

```bash
find ~/[relevant-dirs] -name "*.md" -mtime -[days] 2>/dev/null | sort
```

Or for signal extraction:

```bash
find ~/[dirs] -name "*.md" -mtime -[days] 2>/dev/null \
  | xargs grep -n -i -C2 -E "(pattern1|pattern2|pattern3)" 2>/dev/null
```

**If nothing is found**, stop gracefully:

```
[Gentle message explaining what was missing and how to proceed.]
```

### Step 3: [Classification / Comparison / Filtering]

Describe the logic that transforms raw data into signal. Use a table if classifying:

| Signal Pattern | Category |
|----------------|----------|
| "phrase one", "phrase two" | 🧪 CATEGORY |
| "phrase three"             | 🪡 CATEGORY |

Or describe the layers of comparison (tag resonance → topic resonance → semantic resonance).

**Limit output:** max [n] items per category / max [n] pairings total. Prioritize [criteria].

### Step 4: Write Cache (if applicable)

If this skill produces reusable output, write it to `~/.cache/[skill-name]/YYYY-MM-DD.md`:

```
# [Skill] Cache — YYYY-MM-DD
Generated: YYYY-MM-DD HH:MM
Timeframe: [timeframe]

## CATEGORY
- [signal snippet] ↳ [source file:line]
```

Skip this step if caching is not needed.

### Step 5: Output

Show the exact format of the output as a literal example:

```
[emoji] SKILL NAME — [date or timeframe]

[emoji] CATEGORY — "evocative subtitle"
- "[Signal or insight]"
  → [One sentence on why this matters]
  ↳ [source file path]

───

[emoji] Closing reflection or prompt:
  - [One observation]
  - [One question that opens rather than closes]
```

**Only show categories or sections that have content. Omit empty ones entirely.**

## Supporting Files

List any files this skill reads beyond what the user provides:

- `~/notes/tomes/[file].md` — [what it contains]
- `~/.cache/[skill-name]/` — [cached output from previous runs]
- `~/.ithaca/shell/arcane.sh` — shell rituals (phase of day, season, etc.)

Remove this section if the skill has no supporting files.

## Tone

[Two to four sentences on the register this skill should speak in. What is the user arriving into when they run it? What feeling should the output leave behind? Name what the skill is not — e.g., "not a recommendation engine," "not a productivity audit."]

ARGUMENTS: $ARGUMENTS
