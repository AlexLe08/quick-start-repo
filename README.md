# quick-start-repo

A GitHub template for Alex's new projects: the AI instructions, workflow
rules, CI, PR template, helper scripts and per-language setup that each
earlier project grew on its own, in one place. Pick a language and the
setup script keeps only that one.

## Start a project

You need git and bash (macOS's own are fine). The language's tools come
later: the README the setup script writes lists them.

1. On GitHub, **Use this template → Create a new repository**, then clone
   it.
2. In the new repository's root:

   ```sh
   scripts/init-project.sh typescript --description "One paragraph on what it is."
   ```

   The language is `typescript`, `python`, `java` or `csharp`. Some
   languages offer a choice of tools; the script asks about each, with
   the recommended one as the default, or takes them as flags:

   | Language | Choice | Options (default first) |
   | --- | --- | --- |
   | `typescript` | `--package-manager` | `npm`, `pnpm`, `bun` |
   | `typescript` | `--test` | `vitest`, `node`, `jest` |
   | `python` | `--typecheck` | `mypy`, `pyright`, `ty` |
   | `java` | `--build` | `maven`, `gradle` |

   The project name defaults to the folder's name; pass `--name my-app`
   to change it.
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
| `.claude/settings.json` | Shared Claude Code permissions: no force pushes, no pushes to `main`, no skipping the pre-commit hook, no merging or reviewing PRs, no reading `.env` |
| `.claude/agents/reviewer.md` | A read-only subagent that reviews a branch before its PR |
| `.github/pull_request_template.md` | What changed, screenshots, checklist, what wasn't verified |
| `.github/ISSUE_TEMPLATE/` | Issue forms for bug reports and feature requests, which label the issue `bug` or `enhancement` |
| `.github/workflows/` | `pr-title.yml` (Conventional Commits title, and a label from it), `security.yml` (gitleaks secret scan, zizmor workflow audit), `spelling.yml` (typos); each language adds `ci.yml` and `codeql.yml` |
| `.github/release.yml` | Sorts generated release notes into breaking changes, features, fixes and the rest, by the label `pr-title.yml` sets |
| `.github/rulesets/` | Rulesets to import: `main` protected, squash only, `check`, `pr-title`, `gitleaks` and `typos` required; release tags locked |
| `docs/decisions/` | Decision records, starting with the workflow's |
| `docs/roadmap.md` | Now, Next up, Later, Done |
| `docs/github-setup.md` | The settings to apply by hand |
| `docs/releasing.md` | Versions, changelog, tags, and publishing to npm, for a project that releases |
| `.githooks/pre-commit` | Checks the staged files before each commit: the language's formatter and linter (`scripts/check-staged.sh`), and typos and gitleaks when they're installed. `scripts/setup-worktree.sh` turns it on |
| `scripts/new-worktree.sh` | Starts a task: a branch and worktree from the latest `origin/main` |
| `scripts/cleanup-merged.sh` | After a merge, removes that task's worktree and branch |
| `.typos.toml` | Words the spell checker should accept |
| `.env.example` | Every environment variable the program reads, with safe example values; copied to a gitignored `.env` for real ones |
| `.gitignore`, `.gitattributes`, `.editorconfig` | OS, editor and secret files ignored; LF line endings; indent per file type |
| `SECURITY.md` | Report vulnerabilities privately through GitHub, not in an issue |
| `LICENSE` | MIT, with the year set when the project is set up |

Each language in [`languages/`](languages/) adds its own config, CI and
CodeQL workflows, Dependabot file (monthly, grouped, a week's cooldown),
VS Code settings and debugger launch configuration, starter code and
test, `scripts/check.sh` (everything CI runs, one line per step),
`scripts/check-staged.sh` (the pre-commit hook's quick checks) and
`scripts/setup-worktree.sh`:

| Language | Toolchain |
| --- | --- |
| `typescript` | Node's latest LTS; npm, pnpm or Bun; TypeScript (strict), ESLint (typescript-eslint), Prettier, knip; Vitest, `node:test` or Jest |
| `python` | Python 3.13, uv, ruff, pytest; mypy, pyright or ty; pip-audit in CI |
| `java` | Java 25 (LTS); Maven or Gradle, each through its wrapper; JUnit 6, google-java-format (Spotless), JaCoCo |
| `csharp` | .NET 10 (LTS), xUnit v3, `dotnet format`, analyzers as errors |

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
demo project in each language and with each option, then runs its
`scripts/check.sh`. Projects already created from it don't change; copy
an improvement into them by hand.

A new choice of tools is a folder under `languages/<language>/options/`;
the header of `scripts/init-project.sh` says what goes in it. Add a demo
for each new option to the `init` matrix in `template.yml`.

## License

[MIT](LICENSE)
