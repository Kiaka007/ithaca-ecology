# Brief Not Prompt

*Lightning talk, 7 minutes. OpenMined Retreat, April 23, 2026.*

[**Watch the recording**](https://drive.google.com/file/d/1ptLeZKH-uczsZZVZpRc-wOxfyQdoxnzH/view?usp=drive_link)

---

**[HOOK]**

Hello everyone, my name is Kyoko Eng, I'm an interaction designer and today I'll be talking about context, AI, and a little bit of world-building.

Quick show of hands — how many of you have spent time trying to give an AI agent better context? More background, more of your history so it can respond to you better?

When I started exploring AI tooling, Chat GPT, GPT's sandbox features, Claude, Claude Code etc. I did what we all do and I loaded my chat sessions with a bunch of context hoping over time that I would get better insights. In doing this I started to observe a weird phenomenon.

The more I would use a single agent, even across threads, the more I would find myself stuck in a loop where the agent would fixate on a detail, go down a path I didn't want it to go down, and no matter how much I would rephrase, no matter how much I use the tools at my disposal to optimize the prompt, the agent would keep missing the mark; I couldn't get it on the right train of thought.

This phenomenon fascinated me because as an interaction designer it felt like an oxymoron. As a user I'm jam-packing the system with context, why is it getting worse at interpreting my intention?

It reminded me of the frustrations I used to feel when playing choose your own adventure games on my Dad's PC growing up. In both cases figuratively and quite literally I had to prompt my way out of the dark to understand the logic of the world behind the surface.

And this parallel, this frustration, got me to thinking:

*What if the prompt, this chat interface, isn't the interaction that matters? What if the primary site of interaction we (as product designers) should be focusing on is actually one level up? The brief level, over the prompt level?*

For the past 6 months I have taken that question and with Claude Code have experimented with what it would look like to break out of this prompting loop and instead interact with the AI at the brief level. Using adventure game language, what if my interactions with Claude were not as a player but as the DM (Dungeon Master), the architect.

---

**[LEAD IN]**

What I created was Ithaca — an OS information ecology that combines principles of Contextual Integrity with adventure game conventions. Unlike conventional OS's, Ithaca was built as a **context-first, ritual-based computing ecology** — meaning that the physical structure of the filesystem carries meaning, work has modes rather than just tasks, and that all commands support orientation over automation. In a nutshell I gameified my filesystem and how Claude Code interacts within that filesystem.

---

**[INTRO TO ITHACA]**

**Top Level**: At a top-level, Ithaca's home directory is divided into 3 spheres of context (3 parent folders). Each sphere at the root level has a Claude.md file. Now instead of defining coding patterns or best practices, I'm incorporating a more sociological framing. For each sphere the root Claude.md file defines:

- A **role** that I inhabit while in that sphere
- An imaginary **entity** that sphere serves (a community, a collective, a tradition)
- A **set of norms** for what activities happen within that sphere
- A **set of values** for how those activities take place
- And a list of **NPC** or character definitions which are the personas Claude may inhabit while in that sphere

The governing principle behind this system is: Claude is context-dumb at the global level by design. It arrives knowing nothing. It must read the sphere's CLAUDE.md first to gain context. Only after being briefed by this file can Claude then access the sphere's memories and when invoked assume the persona of the different NPCs within that sphere.

---

**[LESSON]**

This system allowed me to tweak Claude's behavior in a more holistic manner, through the root .md files as opposed to the prompting thread. By doing so here's what surprised me.

By giving Claude boundaries I became more free.

I realized the looping problem that frustrated me before happened because an agent with no boundaries is an agent that doesn't know when to ask. All agents assume, fill gaps to form patterns of answers. The difference between now and before is that now at the brief level I was able to detect and tweak what logic dictates those assumptions. Perhaps this was my biggest lesson:

*Orientation is required for meaningful action, and at its base orientation requires defining boundaries.*

That's the vocabulary of Contextual Integrity. Norms encoded at the origin, boundaries that should be negotiated and change per context. I found that using .md (markdown) files and getting creative with the file architecture are how you can capture these sentiments at a local level.

---

**[ENDING QUESTION]**

At OpenMined we've spent years drawing on contextual integrity to give people control over their data — in breadth, in depth, in texture of interaction. But as we turn towards questions of broad listening maybe the next question we address goes beyond control — maybe the next question is one of authorship.

Instead of at the individual level, what would it look like to give *communities* authorship over their own briefs? How would they collectively reason about their roles, norms, and values? What would they learn about themselves and the technology in the process?

What would it look like to make spheres of context legible and negotiable — not just to each other, but to the tools that mediate our lives?
