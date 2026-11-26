# 0003: Agent roles live in `AGENTS.md`; tool files and skills only point to them

Status: Accepted · 2026-11-26

## Context

Alex's earlier repositories grew their own subagents in `.claude/agents/`:
a reviewer in each, and a planner with backend and frontend implementers
in the-portfolio-site, each with its full instructions in the agent file.
Claude Code is the only AI tool in use today, with others likely later
([decision 0002](0002-agents-md-for-ai-instructions.md)). As of November
2026 each tool defines agents in its own format and folder: Claude Code
in `.claude/agents/*.md`, Codex in `.codex/agents/*.toml`, GitHub Copilot
in `.github/agents/*.agent.md`. Skills share one open format,
[Agent Skills](https://agentskills.io) (`SKILL.md`), which Codex, Copilot
and Cursor read from `.agents/skills/`; Claude Code reads
`.claude/skills/`, where a skill's folder may be a symlink.

## Decision

The template ships three roles: a planner, an implementer and a reviewer,
with the main session orchestrating. Each role is written once, in
`AGENTS.md` ("Agent workflow"); `.claude/agents/` holds one short file
per role that points to it. Skills live in `.agents/skills/`, each linked
from `.claude/skills/`. There are no per-language agents.

**Why:** 

The agent workflow should be part of this quick start setup as a base line. Just about any project will need these three agents in some shape.

## Consequences

- Adding another tool means one short agent file per role in its own
  format, not a copy of the rules.
- A new skill needs its folder in `.agents/skills/` and a link in
  `.claude/skills/`; one without the link reaches every tool but Claude
  Code.
- A role's instructions now load with every session through `AGENTS.md`,
  not only when the agent runs; worth revisiting if `AGENTS.md` grows
  long enough to crowd the context.
- Language specifics come from the commands the setup script adds to
  `AGENTS.md`. A project that needs scoped implementers (one per
  directory, as in the-portfolio-site) adds them itself.
