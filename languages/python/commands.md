## Commands

Python 3.13 (`.python-version`; uv and mise read it), managed with
[uv](https://docs.astral.sh/uv/): `uv.lock` is committed, and every
command runs through `uv run` so it uses the project's `.venv`.

- Install: `uv sync` (`uv add <pkg>` to add a dependency,
  `uv add --dev <pkg>` for a dev tool; never `pip install` into the
  project by hand). Commit `uv.lock` with it.
- `uv run {{PROJECT_NAME}}`: run the program (`src/{{PACKAGE_NAME}}/__main__.py`)
- `uv run ruff check .` / `uv run ruff format .`: lint (pycodestyle,
  pyflakes, isort, bugbear, pyupgrade, simplify) and format, ruff's
  defaults otherwise
- `uv run pytest`: tests in `tests/`, with coverage; fails below
  `--cov-fail-under` in `pyproject.toml`
- `scripts/check.sh`: everything CI's `check` job runs except the
  dependency audit, one line per step. Done means it passes.
- `scripts/new-worktree.sh <branch>`: the next task's worktree;
  `scripts/setup-worktree.sh` (`uv sync --locked`, and the main
  checkout's `.env`) runs inside it.
- `scripts/cleanup-merged.sh [--apply]`: after a merge, lists (or with
  `--apply` removes) worktrees and local branches whose PR merged.

## Code rules

- The package lives in `src/{{PACKAGE_NAME}}/` (src layout), so tests import
  the installed package, not loose files.
- Type hints on every function signature.
- Coverage's floor sits just under the current number; raise it when
  coverage rises, never lower it to pass.
- After changing dependencies in `pyproject.toml`, run `uv lock` and
  commit `uv.lock`.
