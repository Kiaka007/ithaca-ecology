# Design Principles

Five principles underpin every design decision in the Ithaca ecology. They are the constraints that resolve tradeoffs being made with this style of OS versus a more traditional system.

---

## 1. Context Before Action

Establish orientation before making changes.

The sphere system, CLAUDE.md files, and arrival rituals all embody this. Knowing where you are comes before knowing what to do. The global CLAUDE.md makes this explicit to Claude: it must read the sphere's brief before acting.

In practice: when you open a session in a sphere, the first thing that happens is orientation — not execution.

---

## 2. Modes Over Tasks

Work is a state of being, not a task list.

The spaces have names for what happens in them: Explore, Think, Make, Attune. The right question is "what mode am I in?" not "what is on my list?" A task list tells you what to do; a mode tells you how to think.

In practice: `labs/` means exploration — nothing is precious. `workshop/` means obligation — there are deliverables. Moving between them is a conscious act.

---

## 3. Transparency Over Abstraction

Nothing important should be hidden.

Shell commands read as documentation of intent. The file system is legible. CLAUDE.md files are plain text anyone can open, read, and edit. Configurations are visible, not buried in dotfiles. Automation should invite ritual, not obscure it.

In practice: if you can't explain what a file does by reading its name and location, it doesn't belong.

---

## 4. Remember Gently

The system holds context so the human doesn't have to.

Journals, thread handoffs, NPC memory files, and the quest log all exist to reduce the cognitive cost of returning to work after time away. This principle is also about tone: there is no judgment for forgetting. The structure carries memory, not the person.

In practice: `.memory/` files in each sphere hold state between sessions. When you return, Claude reads them and picks up where it left off — without you having to re-explain everything.

---

## 5. Longevity Over Optimization

Plain text. Minimal dependencies. The system should still make sense in five years.

Features are only added when they serve a clear purpose in the ecology. Automation is not valued for its own sake. When in doubt, a simple markdown file beats a clever integration.

In practice: the core of Ithaca is bash + markdown. Both will be readable and editable on any machine, a decade from now, without installing anything.
