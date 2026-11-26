# 0002: AI instructions live in `AGENTS.md`; `CLAUDE.md` only points to it

Status: Accepted · 2026-11-26

## Context

Alex's earlier repositories each kept their agent instructions in a
`CLAUDE.md`, with personal preferences in a gitignored `CLAUDE.local.md`.
Claude Code is the only AI tool in use today, with others likely later.
`AGENTS.md` is the file most other coding agents read, and Claude Code
reads `CLAUDE.md`, which can import another file with `@AGENTS.md`.

## Decision

The project's instructions for any AI agent live in `AGENTS.md`.
`CLAUDE.md` imports it and holds only what is specific to Claude Code.

**Why:**
Preparing for future development efforts involving multiple agent uses from different providers.

## Consequences

- Adding another agent means pointing its own file at `AGENTS.md`, not
  copying the rules.
- A rule added to `CLAUDE.md` instead of `AGENTS.md` reaches only Claude
  Code; reviews should catch that.
- Claude-only pieces (`.claude/settings.json`, subagents, skills) stay in
  `.claude/`.
