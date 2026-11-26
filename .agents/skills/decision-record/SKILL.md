---
name: decision-record
description: Drafts a decision record in docs/decisions/ for a choice that shapes the project or how it's worked on, leaving the Why for the owner. Use when a change adopts, reverses or supersedes such a decision.
---

# Draft a decision record

`docs/decisions/README.md` has the rules; this is the procedure.

1. Read `docs/decisions/README.md` and the records that cover the area,
   to find any this decision supersedes.
2. Copy `docs/decisions/0000-template.md` to the next number, named for
   the decision in a few words: `NNNN-short-name.md`.
3. Fill it in:
   - Title: the decision in a few words.
   - Status: `Accepted · YYYY-MM-DD`, today's date.
   - Context: what was true when it was decided, as facts, with PR
     numbers or commits.
   - Decision: what was decided, in a sentence or two.
   - **Why:** leave `TODO(Alex)`. The owner writes it; never draft it.
   - Consequences: what it makes easier, what it costs, what it rules
     out, and what would make it worth revisiting.
4. Add a row to the table in `docs/decisions/README.md`.
5. If it supersedes a record, set that record's status to
   `Superseded by NNNN`, or `Superseded in part by NNNN (what changed)`,
   and change its row's status to match. Change nothing else in it: an
   accepted record isn't rewritten.
6. The record goes in the PR that acts on the decision. Say in the PR
   that its Why waits on the owner.
