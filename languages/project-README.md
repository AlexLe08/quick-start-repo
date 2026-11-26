# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

<!-- language:getting-started -->

## Working on it

Each change is a small PR to `main`, squash-merged, with a
[Conventional Commits](https://www.conventionalcommits.org/) title
(`feat: …`, `fix: …`). `scripts/check.sh` runs everything CI runs.
`git config core.hooksPath .githooks` once per clone turns on the
pre-commit hook, which checks the staged files
(`scripts/setup-worktree.sh` does it for you).
[AGENTS.md](AGENTS.md) has the full workflow, for people and AI agents
alike.

A few more tools help, on top of the language's:

- [gh](https://cli.github.com), GitHub's command line
  (`brew install gh`, then `gh auth login`): opens PRs from the terminal,
  and lets `scripts/cleanup-merged.sh` tell when a branch was
  squash-merged
- [typos](https://github.com/crate-ci/typos) and
  [gitleaks](https://github.com/gitleaks/gitleaks)
  (`brew install typos-cli gitleaks`): the pre-commit hook and
  `scripts/check.sh` run them when they're installed; CI always does

## Docs

- [docs/roadmap.md](docs/roadmap.md): where the project stands and what's next
- [docs/decisions/](docs/decisions/): why things are the way they are
- [docs/github-setup.md](docs/github-setup.md): repository settings and rulesets
- [docs/releasing.md](docs/releasing.md): versions and releases, if it publishes any

## License

[MIT](LICENSE)
