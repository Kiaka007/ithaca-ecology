# Claude Skills & Agents — Reference Guide

Templates: `~/tools/templates/skill-base.md` · `~/tools/templates/agent-base.md`

---

## Skills vs Commands

- **Built-in commands** — fixed CLI logic (`/help`, `/clear`, `/compact`). Not customisable.
- **Skills** — prompt-based extensions you define. Claude reads the instructions and acts.

---

## Skills

### File locations
- Personal: `~/.claude/commands/<name>.md` or `~/.claude/skills/<name>/SKILL.md`
- Project: `.claude/commands/<name>.md` or `.claude/skills/<name>/SKILL.md`

Invoked with `/name`. Personal scope available across all projects.

### Supporting files
A skill can be a directory with `SKILL.md` as the entry point:
```
~/.claude/skills/my-skill/
├── SKILL.md              ← entry point
├── references/           ← detailed docs
├── templates/            ← output formats
└── scripts/              ← executable scripts
```
Reference supporting files with markdown links in `SKILL.md`. Use `${CLAUDE_SKILL_DIR}` in bash commands to reference files relative to the skill directory.

### Frontmatter fields
| Field | Purpose |
|---|---|
| `name` | Slash command name |
| `description` | What it does — Claude reads this to decide when to auto-invoke |
| `argument-hint` | Shown in autocomplete e.g. `[timeframe]` |
| `disable-model-invocation` | `true` = manual `/name` only, never auto-triggers |
| `user-invocable` | `false` = hidden from `/` menu (background skills only) |
| `allowed-tools` | Pre-approved tools e.g. `Bash, Read` |
| `model` | Override model e.g. `claude-haiku-4-5`, `claude-opus-4-6` |
| `context` | `fork` = run in isolated subagent |
| `agent` | Which agent type when forking: `general-purpose` · `Explore` · `Plan` · custom name |

### Skills in this ecology
- `/oracle [see, decide, communicate]` — checks time of day and season, surfaces phase-appropriate advice on what to pursue next

---

## Skills vs Agents — Decision Guide

| Use a **skill** when... | Use an **agent** when... |
|---|---|
| Output belongs inline in the conversation | Work is verbose or would clutter main context |
| Task is a workflow Claude follows in-session | Task is self-contained and delegable |
| You want results to stream as part of the dialogue | You want results returned as a summary block |
| Tool permissions match the main session | Task needs different permissions or model |
| No cross-session memory needed | Agent should accumulate knowledge over time |

---

## Custom Agents

### File locations
- Personal: `~/.claude/agents/<name>/SKILL.md` or `~/.claude/agents/<name>.md`
- Project: `.claude/agents/<name>/SKILL.md` or `.claude/agents/<name>.md`

Personal agents available across all projects. Project agents take precedence on name conflict.

### Folder structure (complex agents)
```
~/.claude/agents/my-agent/
├── SKILL.md              ← entry point + frontmatter
├── references/
├── templates/
└── scripts/              ← hook validation scripts
```

### Frontmatter fields
| Field | Purpose |
|---|---|
| `name` | Agent name / slash command |
| `description` | When Claude should delegate to it automatically |
| `tools` | Allowlist: `Read, Grep, Glob, Bash, Write, Edit` etc. |
| `disallowedTools` | Explicit blocklist (complement to `tools`) |
| `model` | `claude-haiku-4-5` · `claude-sonnet-4-6` · `claude-opus-4-6` · `inherit` |
| `memory` | `user` · `project` · `local` — see below |
| `permissionMode` | `default` · `acceptEdits` · `dontAsk` · `bypassPermissions` |
| `maxTurns` | Cap on agentic turns before stopping |
| `isolation` | `worktree` = sandboxed git copy |
| `skills` | Preload named skills e.g. `["skill-one", "skill-two"]` |
| `mcpServers` | Inline MCP server config for external tools |
| `hooks` | Lifecycle validation — see below |

### Memory scoping
| Value | Stored at | Scope |
|---|---|---|
| `memory: user` | `~/.claude/agent-memory/<name>/` | All projects, personal |
| `memory: project` | `.claude/agent-memory/<name>/` | This directory, shareable via git |
| `memory: local` | `.claude/agent-memory-local/<name>/` | This directory, private |

Agent auto-loads first 200 lines of `MEMORY.md` from its memory directory each session.
Instruct the agent explicitly to read and update its memory — it won't do so unprompted.

---

## Hooks (Lifecycle Validation)

Intercept what an agent is about to do and allow, block, modify, or observe it.

### Hook events
| Event | Fires | Can block? |
|---|---|---|
| `PreToolUse` | Before a tool call | Yes |
| `PostToolUse` | After a tool completes | No |
| `PostToolUseFailure` | After a tool fails | No |
| `UserPromptSubmit` | When a prompt is submitted | Yes |
| `Stop` | When the agent finishes | No |
| `SubagentStart` / `SubagentStop` | Subagent lifecycle | No |
| `PreCompact` | Before conversation compression | No |
| `PermissionRequest` | When a permission prompt would appear | Yes |

### Matcher
Regex tested against tool name only (not file path or arguments):
```
"Bash"           # only Bash
"Write|Edit"     # Write or Edit
"^mcp__"         # any MCP tool
(omit)           # all tools
```

### Hook decisions
- `allow` — proceed without prompting
- `deny` — block the action
- `ask` — escalate to user
- `updatedInput` — modify tool input before it runs

**Priority:** deny > ask > allow (when multiple hooks apply)

### Hook definition in frontmatter
```yaml
hooks:
  PreToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "${CLAUDE_SKILL_DIR}/scripts/validate.sh"
```

Use hooks for **hard enforcement**. For soft guidance, clear instructions in the agent body are sufficient.
