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
- The `decision-record` skill has the steps for drafting one.

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
  green, then the merge, by whoever Merging (under Agent workflow) names.
  Never push to `main` (the one exception was the setup commit, pushed
  before the rulesets existed). Keep PRs small, one change each; a large
  change is a series of them, each passing the checks. When one PR needs
  another that hasn't merged, base it on that branch and say so.
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
  branch (never `--force`). The reviewer (see Agent workflow) reviews the
  branch before the PR is opened. Only the owner approves PRs and pushes
  release tags; who merges is set under Merging.
- Stage files by name and check `git diff --staged` before committing,
  never `git commit -a`: an editor or tool may have changed tracked files.
- Open the PR with `gh pr create --title "<type>: …" --body-file <file>`,
  the body following `.github/pull_request_template.md` (plain
  `gh pr create` asks for both), or on GitHub. Fill in the template,
  including what you couldn't verify. The `open-pr` skill has the steps.

## Agent workflow

A task too big for one pass is split between specialized agents. Each
role is written once, here; a tool's own agent file (`.claude/agents/`
for Claude Code) only points to its role, so adding another tool means
one short file per role, not a copy of the rules.

- The main session orchestrates. It reads the request and
  `docs/roadmap.md`, asks the planner for a plan when the change is more
  than a small fix, creates each task's worktree
  (`scripts/new-worktree.sh <branch>`), gives each task to an
  implementer, has the reviewer check the branch, opens the PR, and
  merges it when Merging (below) says agents merge. Only the main
  session talks to the owner; agents report to it.
- An agent starts without the conversation: its prompt carries the task,
  the plan step, the worktree path and the branch.
- One implementer per worktree and branch. Tasks that don't depend on
  each other may run at the same time, each in its own worktree.
- Skills are step-by-step procedures any agent can follow, in
  `.agents/skills/<name>/SKILL.md` (the
  [Agent Skills](https://agentskills.io) format; `.claude/skills` links
  there for Claude Code). Add one when the same steps keep being
  explained; add an agent only when the same kind of worker keeps being
  started with the same instructions.

### Planner

Plans one change; read-only, never edits.

1. Read the request, `docs/roadmap.md`, the decision records that cover
   the area, and the code it touches.
2. For each real design decision, compare the realistic options briefly,
   pick one, and say why it beats the others.
3. Write the plan:
   - The goal, and what is out of scope.
   - Tasks in order, each small enough to review as one PR. For each: a
     branch name, the files to change, the tests to add, the rules and
     decision records that apply, and how to verify it beyond
     `scripts/check.sh`.
   - New dependencies (the owner's call), decision records to propose,
     and docs or roadmap updates.
   - Open questions only the owner can answer.

### Implementer

Implements one planned task in the worktree it is given.

1. Work only in that worktree, and check that `git branch --show-current`
   there is the task's branch. No worktree path: stop and ask for one;
   don't create one.
2. Make the change, with tests for new behaviour, and update the docs the
   change touches. Check library APIs against current docs, not memory.
3. Run `scripts/check.sh` until it passes. If it still fails after two
   honest attempts, stop and report rather than widening the change.
4. Commit in small logical steps and push with
   `git push -u origin <branch>`.
5. Report the files changed, the check's output lines, what was verified
   and how, what wasn't, and anything noticed outside the task.

### Reviewer

Reviews one task branch before its PR; read-only, never edits, commits
or pushes. Runs only read-only commands (`git diff`, `git log`,
`git show`, `git status`) and `scripts/check.sh`, which leaves tracked
files untouched. Never runs anything that reaches production or a live
service.

1. In the worktree it is given, read the task, then
   `git diff origin/main...HEAD` and `git status` (leftover uncommitted
   files are a finding).
2. Check:
   - Every rule in this file the diff touches, and any decision record
     that covers the changed area.
   - Correctness: bugs, edge cases, error handling, and what happens when
     a call fails.
   - Security: secrets in code or logs, unchecked input, and anything a
     user could make the program do that they shouldn't.
   - Tests: new behaviour is tested; no test was deleted, skipped, or
     loosened, except the tests of code the task deletes, and the PR says
     so.
   - Scope: no drive-by refactors, renames or new dependencies.
   - Docs: the README and `docs/` pages that now need an edit, and
     `docs/roadmap.md`: the branch's Done entry, and its Next up or Later
     item moved or removed.
3. Run `scripts/check.sh` to confirm the result.
4. Report each finding as `path:line`, severity (blocker, should-fix,
   nit), the rule or reason, and a suggested fix. Then what was checked,
   what wasn't, and a verdict: pass or changes needed.

### Merging

Merges: owner

The owner sets this line to `owner` or `agents`, per project; agents
never change it.

- `owner`: the main session stops at the open PR and reports it; the
  owner reviews and merges.
- `agents`: the main session merges its own PR once the reviewer's
  verdict is pass, every required check is green on the PR's head, the
  PR has no conflicts, and no comment on it asks to wait. It merges that
  exact head, `gh pr merge <number> --squash --match-head-commit <sha>`,
  then runs `scripts/cleanup-merged.sh --apply` and reports what merged.
  If GitHub refuses because the branch is behind `main`, it merges
  `origin/main` into the branch, pushes, and waits for the checks again.
  A PR waits for the owner instead when it adds a runtime dependency,
  publishes a release, or changes `.github/`, `.githooks/`,
  `.claude/settings.json` or this section.

Switching to `agents` also means deleting `"Bash(gh pr merge *)"` from
the `deny` list in `.claude/settings.json`, which blocks merging while
the line says `owner`. Approving PRs, pushing release tags and approving
deploys stay with the owner either way.
