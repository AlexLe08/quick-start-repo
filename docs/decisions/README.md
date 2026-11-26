# Decision records

One short file per decision that shapes the project or how it's worked on,
numbered in order: what was decided, the context it was decided in, and
what follows from it. They record why things are the way they are, so a
later change can tell a deliberate choice from an accident.

- A new record copies [`0000-template.md`](0000-template.md) as the next
  number, and goes in the PR that acts on the decision (or its own, if
  nothing changes yet).
- A record isn't rewritten once accepted. To change a decision, write a
  new record and set the old one's status to `Superseded by NNNN`, or
  `superseded in part by NNNN (what changed)` when the rest still stands.
- The **Why** is the owner's. Agents draft Context and Consequences from
  the history and leave the Why as `TODO(Alex)`.

The records below came with the
[quick-start-repo](https://github.com/AlexLe08/quick-start-repo) template;
they hold for this project until a new record supersedes one.

| Record                                        | Decision                                                                  | Status                |
| --------------------------------------------- | ------------------------------------------------------------------------- | --------------------- |
| [0001](0001-small-prs-squash-only.md)         | Small PRs to `main`, squash-merged, titled in Conventional Commits        | Accepted · 2026-11-26 |
| [0002](0002-agents-md-for-ai-instructions.md) | AI instructions live in `AGENTS.md`; `CLAUDE.md` only points to it        | Accepted · 2026-11-26 |
| [0003](0003-agent-roles-in-agents-md.md)      | Agent roles live in `AGENTS.md`; tool files and skills only point to them | Accepted · 2026-11-26 |
| [0004](0004-who-merges-is-per-project.md)     | Who merges is set per project, the owner by default                       | Accepted · 2026-11-26 |
