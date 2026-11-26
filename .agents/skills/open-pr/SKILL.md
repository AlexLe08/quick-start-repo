---
name: open-pr
description: Opens the pull request for a finished task branch, with the title and body this project expects. Use when a task's branch is committed, pushed and reviewed, and it's time for the PR.
---

# Open a pull request

Opens the PR for one task branch. Never approve or review it; whether
the main session then merges it is set under Merging in `AGENTS.md`.

1. Check the branch is ready: everything committed (`git status` is
   clean), `scripts/check.sh` passes, and the reviewer's verdict was
   pass, or each of its findings is fixed or answered.
2. Push it: `git push -u origin <branch>` (never `--force`, never
   `main`).
3. Write the title as a commit subject in Conventional Commits form, the
   type matching the branch's (`feat/dark-mode` → `feat: dark mode`). It
   becomes the squash commit on `main`.
4. Write the body to `.logs/pr-body.md`, following
   `.github/pull_request_template.md`: what changes and why in a few
   lines, screenshots (or "None: no visible change."), the checklist
   ticked only where true, and what wasn't verified (or "Nothing"). Name
   any test removed with the code it tested.
5. Open it: `gh pr create --title "<type>: …" --body-file .logs/pr-body.md`.
6. Report the PR's link and what it waits on: CI, then the owner's
   review and merge, or, with `Merges: agents`, the merge as `AGENTS.md`
   describes it.
