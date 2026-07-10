# Address Book

## Purpose

This directory has two distinct jobs. Keep them separate — they serve
different lookups and have different schemas.

1. **`sources/`** — vetted institutions, journals, publications, and
   thought-leaders/influencers. These are first-stop references: when a
   question falls into a subject area tracked here, check these before a
   generic web search.
2. **`people.yaml`** — individuals with consistent contact (friend, colleague,
   collaborator, family). This is identity and relationship-standing
   resolution: when the user or an NPC says a name, this is how you know
   "who" without being re-briefed on the relationship every time.

## `sources/` — Trusted Reference Points

Each `.yaml` file in `sources/` represents a subject domain (e.g.
`academic.yaml`, `local-arts.yaml`, `open-source.yaml`, `farming.yaml`).
File names are lowercase with hyphens. Contacts within a file:

| Field | Values | Meaning |
|-------|--------|---------|
| `type` | individual, organization, institution, publication, community | What kind of entity |
| `alignment` | 1–5 | Priority/trust weight — 5 outranks 1 when citing or listing |
| `url` | URL | Where they publish or can be found |
| `why_track` | free text | Brief note on relevance |
| `areas` | list of tags | Subject-matter tags — **this is what routing matches against** |
| `known_contact` | name (optional) | Set only when a named person in `people.yaml` is the reason this org is tracked |

**How to use:**
- When a question's subject matches an `areas` tag in any `sources/*.yaml`
  file, treat those URLs as first-stop references before a general web
  search. Cite the entry's `name` and use `why_track` to explain relevance.
- Use `alignment` to prioritize among multiple matching entries.
- When sourcing opportunities or evaluating fit, check `known_contact` — a
  named connection there is worth surfacing before a cold approach.
- This is curated, not exhaustive. Brief entries are fine; not every source
  needs a filled-in `why_track`.

## `people.yaml` — Relationship Registry

A single flat list, not split by domain — the same person shouldn't be
duplicated across multiple circle files. Fields:

| Field | Meaning |
|-------|---------|
| `aliases` | Nicknames/alternate names — helps resolve who's meant |
| `circles` | Tags linking back to the `sources/<circle>.yaml` this person is associated with |
| `relationship_type` | friend, collaborator, colleague, family, mentor, acquaintance |
| `context` | Who they are / how the user knows them — the disambiguation anchor when only a first name is given |
| `last_contact` | Lightweight date only. **No history log here** — see below |
| `notes` | Current standing impression, freeform |
| `caution` | Optional — only filled in when something's actually worth flagging |
| `contact` | Optional url/instagram/etc. |

**How to use:**
- When a name comes up, check `people.yaml` first before asking the user who
  they mean. Use `aliases` and `context` to disambiguate between people who
  might share a first name.
- Don't repeat the user's own relationship description back to them if it's
  already captured in `context` — that's what this file is for.
- If `caution` is filled in, surface it gently when relevant (e.g. before
  suggesting outreach), rather than ignoring it.

### Relationship to `.memory/relationships.md`

`people.yaml` is the static identity/last-contact record. The detailed,
session-by-session log of touchpoints and patterns lives exclusively in
`sp_town/.memory/relationships.md` — do not duplicate history into both
places. When the Tavern Keeper logs a new touchpoint in
`.memory/relationships.md`, it should also refresh that person's
`last_contact` date here.

### Cross-referencing sources and people

`known_contact` (on a source entry) and `circles` (on a person entry) are how
the two files link without duplicating data. If a source's relevance is
really about a specific person, name them via `known_contact` there and give
them a full entry here rather than leaving them as prose in a `why_track`
field.

## Updating

This is a living address book. Update `sources/` as new institutions or
influencers become relevant, and `people.yaml` as relationships form or
change. Templates: `bag/tools/templates/source-contact.yaml` and
`bag/tools/templates/person-contact.yaml`.
