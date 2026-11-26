# Releasing

Only for a project that publishes versions: a package others install, or
an app whose releases are worth naming. Most projects never need this;
merging to `main` is enough.

## Versions

Versions follow [semver](https://semver.org/), `MAJOR.MINOR.PATCH`, keyed
to whatever users of the project rely on (its API, config or CLI):

- **Patch** (`1.0.1`): a fix, nothing a user has to change.
- **Minor** (`1.1.0`): something new that existing users can ignore.
- **Major** (`2.0.0`): anything that can break a user: a removed or
  renamed export, option or command, a new required field, changed
  behaviour they rely on. The PR that breaks it says what breaks.
- **Prerelease** (`2.0.0-beta.0`, then `beta.1`): a version to try before
  the real one.

Before `1.0.0`, anything may change; start at `0.1.0` and go to `1.0.0`
once someone depends on it.

## Changelog

Add `CHANGELOG.md` with the first release, in the
[Keep a Changelog](https://keepachangelog.com/) shape:

```md
# Changelog

## Unreleased

### Added

- …

## 1.0.0 - 2026-12-01

…
```

Each PR that changes something a user can see adds a line under
Unreleased, in the same PR (Added, Changed, Fixed, Removed). Internal
changes (CI, refactors, tests) get no line.

## Cutting a release

1. A PR titled `release: X.Y.Z` (branch `release/X.Y.Z`) that sets the
   version (`package.json`, `pyproject.toml`, `pom.xml` or the `.csproj`)
   and turns Unreleased into `## X.Y.Z - <date>`. Nothing else goes in it.
2. Merge it (squash, as always).
3. Tag that squash commit on `main` and push the tag:

   ```sh
   git switch main && git pull
   git log -1 --oneline        # check it's the release commit
   git tag vX.Y.Z && git push origin vX.Y.Z
   ```

4. Optionally, a GitHub Release from the tag (Releases → Draft a new
   release, or `gh release create vX.Y.Z --notes-from-tag`), with the
   changelog's section as its notes.

Tags are plain `v` plus the version (`v1.4.0`, `v2.0.0-beta.1`). The tags
ruleset ([`.github/rulesets/tags.json`](../.github/rulesets/tags.json), see
[github-setup.md](github-setup.md)) stops a pushed `v*` tag from being
moved or deleted, so check the commit before pushing; a wrong tag is fixed
with the next version, never by moving it. Only the owner pushes release
tags; `.claude/settings.json` makes Claude Code ask before pushing one.

## Publishing to npm

For a TypeScript package, publish from CI when a tag is pushed, never from
a laptop. npm's [trusted publishing](https://docs.npmjs.com/trusted-publishers)
checks the workflow's identity instead of a stored token and adds
provenance itself. Free for public packages.

1. In `package.json`: remove `"private": true`, set `"name"` (a scope such
   as `@you/name` needs that npm user or a free npm organization),
   `"version"`, `"files"` (what to publish, such as `["dist"]`),
   `"exports"`, `"license": "MIT"` and `"repository"`. Run
   `npm pack --dry-run` to see what would go out.
2. Add `.github/workflows/release.yml`:

   ```yaml
   name: Release

   on:
     push:
       tags: ["v*"]

   permissions:
     contents: read
     id-token: write # the OIDC token npm checks

   jobs:
     publish:
       runs-on: ubuntu-latest
       timeout-minutes: 15
       steps:
         - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
           with:
             persist-credentials: false
         # No dependency cache in a job that publishes: a poisoned cache
         # entry would end up in the release.
         - uses: actions/setup-node@949feb2413d6458794dcd2491c4babbbce0c15c1 # v7.1.0
           with:
             node-version-file: .nvmrc
             package-manager-cache: false
             registry-url: "https://registry.npmjs.org"
         - name: Tag matches package.json
           run: |
             version="$(node -p 'require("./package.json").version')"
             if [[ "v$version" != "$GITHUB_REF_NAME" ]]; then
               echo "tag $GITHUB_REF_NAME doesn't match version $version"
               exit 1
             fi
         - run: npm ci
         - run: scripts/check.sh
         # A prerelease goes to the `next` dist-tag, so a plain
         # `npm install` keeps getting the latest stable version.
         - name: Publish
           run: |
             version="$(node -p 'require("./package.json").version')"
             if [[ "$version" == *-* ]]; then npm publish --tag next; else npm publish; fi
   ```

3. On npmjs.com, the package's Settings → Trusted publishing → GitHub
   Actions: the GitHub user, the repository, workflow `release.yml`
   (file name only), no environment, and `npm publish` allowed. Every field
   is case-sensitive and nothing is checked until a publish, so set it up
   when a tagged release will follow. A brand-new package name can't have
   a trusted publisher yet; npm's docs cover the first publish.
4. Once a release has gone through, set Settings → Publishing access to
   "Require two-factor authentication and disallow tokens".

Python (PyPI), Maven Central and NuGet offer trusted publishing too; set
it up from their docs when a project needs it, and record the choice in
`docs/decisions/`.
