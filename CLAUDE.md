# CLAUDE.md

@AGENTS.md

`AGENTS.md` holds this project's instructions for every AI agent; keep
them there, not here. This file is only for what is specific to Claude
Code:

- Shared permissions are in `.claude/settings.json`; personal ones go in
  `.claude/settings.local.json` (gitignored).
- Subagents live in `.claude/agents/`, one short file per role in
  `AGENTS.md` ("Agent workflow"), pointing to it.
- Skills live in `.agents/skills/`, shared with other tools. Claude Code
  looks in `.claude/skills/`, so each skill is linked from there:

  ```sh
  ln -s ../../.agents/skills/<name> .claude/skills/<name>
  ```
