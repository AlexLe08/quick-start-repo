# AGENTS.md

Instructions for AI coding agents working in this repository (Claude Code
reads them through `CLAUDE.md`). Personal working-style preferences live in
`CLAUDE.local.md` (gitignored). Current status and next steps live in
`docs/roadmap.md`: read it when starting a task. `README.md` is the
reference for what the project does and how to run it; read the doc that
covers an area before changing it, and update it in the same PR when that
area changes.

## What this is

{{PROJECT_DESCRIPTION}}

## Decision records

`docs/decisions/` holds one record per decision that shapes the project or
the workflow, indexed in its `README.md`.

- Before changing an area a record covers, read the record.
- Don't quietly go against one. Propose a new record that supersedes it,
  in the PR that changes course, and say so in the PR.
- Never write a record's **Why**: draft Context and Consequences from the
  history and leave the Why as `TODO(Alex)` for the owner.

<!-- language:commands -->

## Docs

- `README.md`: what the project is, how to install, run and test it, and
  links into `docs/`. Keep it to what someone needs to get started.
- `docs/`: anything longer (architecture, deployment, runbooks, plans),
  one file per subject, linked from the README.
- `docs/roadmap.md`: Now, Next up, Later and Done. A feature's Done entry
  goes in the feature's own PR, which also moves or removes its Next up
  or Later item.
- `docs/decisions/`: decision records, as above.
- `docs/releasing.md`: versions, the changelog and tags, for when the
  project starts releasing.
- Comments say why, not what: the reason, the constraint, the incident
  behind a choice. No comments that explain the language, and no
  commented-out code.

## Hard constraints

- Free tiers only. Never configure or suggest anything that needs a
  payment method or a paid plan. If a feature is paid-only, find a free
  workaround or ask first.
- Never commit secrets. `.env` files are gitignored; variable names are
  documented in `.env.example`. Never read, print or edit a real `.env`.
- Adding a runtime dependency is a design decision for the owner, not an
  implementation detail.
- CI's required checks are named by job id in the `main` ruleset. Don't
  rename a job without updating the ruleset, and don't add `paths:`
  filters to the `pull_request` trigger (a required check that never runs
  waits forever).
- The language's version comes from the project's version file
  (`.nvmrc`, `.python-version`, `.java-version` or `global.json`), which
  mise and CI read. Never change a global version (`mise use -g`,
  `brew install` a language) to get something running; if the pin looks
  wrong, say so. Command-line tools (gh, typos, gitleaks) come from
  Homebrew.
- Never change global Git config (`git config --global`): the owner's
  `~/.gitconfig` is a link into a dotfiles repository, so the change
  would land there. Settings for this repository alone (plain
  `git config`) are fine.
- A service the project runs locally (a database, a queue) is defined in
  `compose.yaml`: the image pinned to a major version, ports bound to
  `127.0.0.1`, credentials read from `.env`. `docker compose down -v`
  deletes its data; never run it, ask the owner to.

## Workflow

- `main` is protected by a ruleset: branch off `main`, open a PR, CI
  green, the owner merges. Never push to `main` (the one exception was the
  setup commit, pushed before the rulesets existed). Keep PRs small, one
  change each; a large change is a series of them, each passing the
  checks. When one PR needs another that hasn't merged, base it on that
  branch and say so.
- Commits and PR titles follow
  [Conventional Commits](https://www.conventionalcommits.org/):
  `feat`, `fix`, `docs`, `test`, `ci`, `refactor`, `chore`, `deps`,
  `perf`, `build`. Branches are `<type>/<what-in-kebab-case>`, the type
  matching the PR title's (`feat/dark-mode`, `fix/login-redirect`).
- PRs are squash-merged, the only merge the repository allows: the PR
  title and body become the one commit on `main`, so write the title like
  a commit subject. GitHub deletes the branch on merge.
- Each task starts in a new worktree under `.claude/worktrees/`
  (gitignored): `scripts/new-worktree.sh <branch>` branches from the
  latest `origin/main` with no upstream and runs
  `scripts/setup-worktree.sh` there. With no upstream, a bare `git push`
  can't hit `main`; push with `git push -u origin <branch>`.
- Once the PR has merged, run `scripts/cleanup-merged.sh` (a dry run),
  then `--apply`, to remove its worktree and local branch.
- The pre-commit hook (`.githooks/pre-commit`, turned on by
  `scripts/setup-worktree.sh`) checks the staged files: formatting and
  lint, and spelling and secrets where typos and gitleaks are installed.
  Never skip it with `--no-verify`; fix what it reports.
- Done means `scripts/check.sh` passes. It runs what CI runs, one line per
  step, with full logs in `.logs/`.
- Scratch files (probe scripts, logs) go in `.logs/` (gitignored).
- Tests: never delete, skip, or loosen a test, or change its expected
  values, to make a check pass. If a test looks wrong, stop and report
  why. New behaviour gets new tests. Deleting code deletes its tests; say
  so in the PR.
- Stay inside the task: no drive-by refactors, renames, or new
  dependencies; list what you noticed instead.
- Commit in small logical steps. Agents may commit and push their task
  branch (never `--force`). The `reviewer` agent (`.claude/agents/`)
  reviews the branch before the PR is opened; only the owner approves,
  merges, and pushes release tags.
- Stage files by name and check `git diff --staged` before committing,
  never `git commit -a`: an editor or tool may have changed tracked files.
- Open the PR with `gh pr create --title "<type>: …" --body-file <file>`,
  the body following `.github/pull_request_template.md` (plain
  `gh pr create` asks for both), or on GitHub. Fill in the template,
  including what you couldn't verify.
