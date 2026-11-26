# GitHub setup

Settings a template can't carry: GitHub copies a template's files into a
new repository, but not its settings. Do these once, right after creating
the repository and pushing the first commit from `scripts/init-project.sh`.
All of them are free for public repositories; private ones on a free plan
can't enforce rulesets.

## General (Settings → General)

Under **Pull Requests**:

- Untick **Allow merge commits** and **Allow rebase merging**, leaving
  **Allow squash merging** on, with the default commit message set to
  **Pull request title and description**
  ([decision 0001](decisions/0001-small-prs-squash-only.md)).
- Tick **Always suggest updating pull request branches**.
- Tick **Automatically delete head branches**.

## Rulesets (Settings → Rules → Rulesets)

**New ruleset → Import a ruleset**, once for each file:

- [`.github/rulesets/main.json`](../.github/rulesets/main.json): `main`
  can't be deleted or force-pushed, changes go through a PR merged by
  squash, and the `check` (`ci.yml`), `pr-title` and `gitleaks`
  (`security.yml`) jobs must pass on a branch that is up to date with
  `main`. No approval is required, since one person owns the
  repository; the owner merges by convention.
- [`.github/rulesets/tags.json`](../.github/rulesets/tags.json): a pushed
  `v*` tag can't be moved or deleted. Only needed for a project that
  publishes releases.

A required check is named by its job id. Renaming a CI job means updating
the ruleset, or every PR waits for a check that never comes.

## Security (Settings → Code security)

- **Dependabot alerts** and **Dependabot security updates**: on.
- **Secret scanning** and **Push protection**: on (free for public
  repositories).
- **Private vulnerability reporting**: on. `SECURITY.md` asks people to
  report problems that way, and the new-issue page links to it.
- **Code scanning**: nothing to set up; `.github/workflows/codeql.yml`
  uploads its results. It needs a public repository (or paid Advanced
  Security), so delete that workflow in a private one. zizmor in
  `security.yml` prints its findings in the job log instead, so it works
  either way.

## Actions (Settings → Actions → General)

- **Workflow permissions**: **Read repository contents and packages
  permissions**. Each workflow asks for anything more itself.
- Leave **Allow GitHub Actions to create and approve pull requests**
  unticked.
