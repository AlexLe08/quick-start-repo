# 0004: Who merges is set per project, the owner by default

Status: Accepted · 2026-11-26

## Context

Alex's earlier repositories, and this template until now, had agents
stop at an open PR: the owner reviews and merges every one, and
`.claude/settings.json` denies `gh pr merge`. Some projects made from the
template will be worked hands-off, with the owner asking for tasks rather
than reviewing each PR, so the merge would be the only step waiting on
the owner. The `main` ruleset requires no approval, only a PR, squash
merges and green required checks on an up-to-date branch, so GitHub
allows the agent's own merge once the settings deny is lifted.

## Decision

`AGENTS.md` has a `Merges:` line, `owner` (the default) or `agents`, that
the owner sets per project. With `agents`, the main session merges its own
PR after the reviewer passes it and CI is green, except PRs that add a
runtime dependency, publish a release or change the project's guard rails
(`.github/`, `.githooks/`, `.claude/settings.json`, the Merging section).

**Why:** TODO(Alex)

## Consequences

- A hands-off project needs two edits: the `Merges:` line and the
  `gh pr merge` deny in `.claude/settings.json`.
- With `agents`, no person reads a change before it lands on `main`; the
  tests, CI and the reviewer agent are the only checks, so a project's
  test coverage matters more.
- Changes to the checks themselves still wait for the owner, so an agent
  can't loosen what guards its own merges.
- Approving PRs, release tags and deploys stay with the owner in both
  modes.
