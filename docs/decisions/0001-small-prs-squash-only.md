# 0001: Small PRs to `main`, squash-merged, titled in Conventional Commits

Status: Accepted · 2026-11-26

## Context

Alex's earlier repositories started with merge commits and a commit per
small step on `main`, then moved to squash merges one at a time
(wol-character-panel's decision 0005 on 2026-11-14, shrimp-fried-this-rice's
0001 after it). Each one also grew the same worktree scripts
(`scripts/new-worktree.sh`, `scripts/cleanup-merged.sh`) and branch names
like `fix/…`, with PR titles written as commit subjects. This template
starts new projects from that end state.

## Decision

Work lands as small PRs to `main`, one change each, squash-merged: the PR
title and body become the one commit. Titles and branch names follow
Conventional Commits (`feat: …` on `feat/…`). The repository allows squash
merges only and deletes head branches on merge; a ruleset protects `main`.

**Why:**

Ideally treat main history as a changelog so that there is not a pile of unnecessary small commits in the history at a glance. Keep it readable and simple at main, other branches can afford to be more descriptive in their commit history.

## Consequences

- `main`'s history is one commit per PR, titled by the PR, so it reads as
  a changelog.
- Commits inside a branch can stay small for review; they don't reach
  `main`.
- A large change is a series of PRs, each passing the checks.
- `scripts/cleanup-merged.sh` has to ask GitHub (`gh`) whether a branch
  was squash-merged, since a squash merge leaves no ancestry to check.
- These repository settings don't copy with a template; each new
  repository sets them once (`docs/github-setup.md`).
