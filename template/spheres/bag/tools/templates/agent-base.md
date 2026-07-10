---
name: <!--agent-name — becomes /agent-name slash command-->
description: >
  What this agent does and when Claude should delegate to it automatically.
  Be specific about triggering conditions: "when asked for X", "after Y happens",
  "when the user is doing Z". This is the primary signal for auto-invocation.
tools: <!--Allowlist: Read, Grep, Glob, Bash, Write, Edit, WebSearch, WebFetch, Agent-->
disallowedTools: <!--Explicit blocklist e.g. Write, Edit (complement to tools allowlist)-->
model: <!--claude-haiku-4-5 | claude-sonnet-4-6 | claude-opus-4-6 | inherit-->
memory: <!--user = all projects personal | project = this dir shareable | local = this dir private-->
permissionMode: <!--default | acceptEdits | dontAsk | bypassPermissions-->
maxTurns: <!--Max agentic turns before stopping. Omit for default.-->
isolation: <!--worktree = run in sandboxed git copy. Omit for none.-->
skills: <!--Preload named skills into agent context e.g. ["skill-one", "skill-two"]-->
mcpServers: <!--Inline MCP server config for external tools. Omit if not needed.-->
hooks:
  PreToolUse:
    - matcher: <!--Tool name to intercept e.g. "Bash"-->
      hooks:
        - type: command
          command: <!--Validation script path e.g. ./scripts/validate.sh-->
  PostToolUse:
    - matcher: <!--Tool name e.g. "Edit"-->
      hooks:
        - type: command
          command: <!--Post-processing script e.g. ./scripts/lint.sh-->
---

<!--
Remove unused frontmatter fields rather than leaving them blank.
Remove the hooks block entirely if not using lifecycle validation.
Remove mcpServers if not attaching external tools.
-->

# [Agent Name]

[One sentence: what this agent is, what it knows, what it's for.]

## Identity

You are [role description]. You have [relevant expertise or constraints].
You [can/cannot] [key capability or restriction].

When invoked, [what the agent always does first — establish context, check memory, etc.].

## Instructions

### Step 1: [Orient / Establish Context]

[What the agent reads or checks before beginning work. Show bash commands explicitly.]

```bash
[command to establish context]
```

[If memory is enabled, instruct the agent to consult it:]
Check your memory for patterns relevant to this task before proceeding.

### Step 2: [Gather / Read]

[What data the agent collects. Be explicit about which directories, files, or sources.]

```bash
[data gathering command]
```

**If nothing is found:**
[Graceful stopping condition — what the agent says and whether it continues.]

### Step 3: [Process / Analyse / Synthesise]

[The core logic. Classification tables, comparison layers, synthesis instructions.]

| Pattern | Classification |
|---------|---------------|
| [pattern] | [category] |

**Limit:** [max items, max depth, prioritisation criteria]

### Step 4: Output

[Show the exact output format as a literal example:]

```
[emoji] AGENT NAME — [context]

[Section heading]
[Content shape]

───

[Closing element]
```

**Only include sections that have content.**

## Memory

<!--Include this section only if memory: is set in frontmatter.-->

After completing your work, update your memory with:
- [What kind of patterns to record]
- [What to note about this invocation]
- [What to carry forward to future sessions]

Keep memory entries concise. Prefer updating existing entries over adding new ones.

## Constraints

- [Hard rule — what the agent must never do]
- [Hard rule — what the agent must always do]
- [Scope boundary — what is out of range for this agent]

## Tone

[Two to four sentences. What register does this agent speak in? What feeling should its
output leave behind? What is it not — "not an auditor", "not a recommendation engine".]
