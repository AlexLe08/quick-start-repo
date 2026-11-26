# quick-start-repo

A GitHub template for Alex's new projects: the AI instructions, workflow
rules, CI, PR template, helper scripts and per-language setup that each
earlier project grew on its own, in one place. Pick a language and the
setup script keeps only that one.

## Start a project

1. On GitHub, **Use this template → Create a new repository**, then clone
   it.
2. In the new repository's root:

   ```sh
   scripts/init-project.sh typescript --description "One paragraph on what it is."
   ```

   The language is `typescript`, `python`, `java` or `csharp`. The project
   name defaults to the folder's name; pass `--name my-app` to change it.
3. Follow the steps it prints: review the diff, install, run
   `scripts/check.sh`, commit and push.
4. Apply the repository settings and rulesets in
   [docs/github-setup.md](docs/github-setup.md); a template can't carry
   them.

The script only changes files. Before the first commit,
`git restore . && git clean -fd` undoes it.

## What's in it

Every project gets:

| Path | What it's for |
| --- | --- |
| `AGENTS.md` | Instructions for any AI agent: workflow, docs, hard rules. The language's commands are added to it. |
| `CLAUDE.md` | Imports `AGENTS.md`, plus what is specific to Claude Code |
| `.claude/settings.json` | Shared Claude Code permissions: no force pushes, no pushes to `main`, no merging or reviewing PRs, no reading `.env` |
| `.claude/agents/reviewer.md` | A read-only subagent that reviews a branch before its PR |
| `.github/pull_request_template.md` | What changed, screenshots, checklist, what wasn't verified |
| `.github/workflows/` | `pr-title.yml` (Conventional Commits title), `security.yml` (gitleaks secret scan, zizmor workflow audit); each language adds `ci.yml` and `codeql.yml` |
| `.github/rulesets/` | Rulesets to import: `main` protected, squash only, `check`, `pr-title` and `gitleaks` required; release tags locked |
| `docs/decisions/` | Decision records, starting with the workflow's |
| `docs/roadmap.md` | Now, Next up, Later, Done |
| `docs/github-setup.md` | The settings to apply by hand |
| `docs/releasing.md` | Versions, changelog, tags, and publishing to npm, for a project that releases |
| `scripts/new-worktree.sh` | Starts a task: a branch and worktree from the latest `origin/main` |
| `scripts/cleanup-merged.sh` | After a merge, removes that task's worktree and branch |
| `.gitignore`, `.gitattributes`, `.editorconfig` | OS, editor and secret files ignored; LF line endings; indent per file type |
| `LICENSE` | MIT, with the year set when the project is set up |

Each language in [`languages/`](languages/) adds its own config, CI and
CodeQL workflows, Dependabot file (monthly, grouped, a week's cooldown),
editor settings, starter code and test, `scripts/check.sh` (everything CI
runs, one line per step) and `scripts/setup-worktree.sh`:

| Language | Toolchain |
| --- | --- |
| `typescript` | Node 24, npm, TypeScript (strict), ESLint (typescript-eslint), Prettier, Vitest |
| `python` | Python 3.13, uv, ruff, pytest, pip-audit in CI |
| `java` | Java 25, Maven, JUnit 6, google-java-format (Spotless), JaCoCo |
| `csharp` | .NET 10, xUnit v3, `dotnet format`, analyzers as errors |

Claude Code adds no co-author line to commits or PRs
(`attribution` in `.claude/settings.json`); delete that setting to bring
it back.

## Conventions

- Small PRs to `main`, squash-merged, titled in
  [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat: …`), on branches named `feat/…`
  ([decision 0001](docs/decisions/0001-small-prs-squash-only.md)).
- `README.md` says what the project is and how to run it; anything longer
  goes in `docs/`, and decisions in `docs/decisions/`.
- AI instructions live in `AGENTS.md`
  ([decision 0002](docs/decisions/0002-agents-md-for-ai-instructions.md)).
- Free tiers only.

## Changing the template

Work on the template itself follows the same rules: a branch, a PR,
CI green. The template's own CI (`.github/workflows/template.yml`, which
the setup script deletes) runs shellcheck on every script and sets up a
demo project in each language, then runs its `scripts/check.sh`. Projects already created from it don't change; copy an
improvement into them by hand.

## License

[MIT](LICENSE)
