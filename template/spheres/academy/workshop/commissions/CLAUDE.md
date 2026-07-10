# sp_academy/workshop/commissions — Commissions

## Mode: Commissions

This is a space for bounded commitments. Commissions carry obligation and require deliverables. They have beginnings, middles, and ends.

Unlike threads (which carry thought), commissions carry responsibility. Entering a commission means accepting that something must be produced.

## Structure

Each commission is a directory containing:

- **design/** — Intentional choices about form, structure, interface.
- **research/** — References to `library/notes/research/`, not duplicates. Typically a `.md` file linking to relevant research notes. Exception: research too specific to the commission to live elsewhere (e.g., client organizational context).
- **prototypes/** — Working attempts. Things that run, even if rough.
- **outputs/** — Deliverables. The things that leave this space.

Commissions may also contain a `README.md` describing scope, status, and commitments.

## Lifecycle

Commissions are bounded. They should end.

- A commission can be **active** (work underway toward deliverable)
- A commission can be **blocked** (waiting on external dependency)
- A commission can be **complete** (deliverable produced → archive)
- A commission can be **abandoned** (ended without deliverable — this is a choice, not a failure to acknowledge)

## Shell Commands

| Command | Effect |
|---------|--------|
| `commissions` | Go to commissions root |
| `prjx <name>` | Create new commission with subdirs |
| `status [hours]` | See commission files touched recently |

## Working Here

- Be clear about what the deliverable is
- Design captures intent; prototypes test it; outputs embody it
- Research here references `library/notes/research/` — don't duplicate, link
- Commission-specific research (client context, internal details) can live here as an exception
- When a commission is complete, move it to `library/archive/`
- If a commission loses its deliverable but retains interest, it may dissolve back into a thread
