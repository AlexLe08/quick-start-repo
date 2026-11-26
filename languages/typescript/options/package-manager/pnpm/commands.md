- `pnpm-workspace.yaml`: pnpm's settings. `allowBuilds` says which
  dependencies may run install scripts; when an install fails on a new
  one, read what its script does before `pnpm approve-builds` allows it.
