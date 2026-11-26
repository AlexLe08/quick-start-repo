#!/usr/bin/env bash
# Turns a fresh copy of the quick-start-repo template into a project in one
# language. Run it once, in the new repository's root, before the first
# real commit:
#
# 1. copies languages/<language>/files/ over the repository root (its
#    config, CI workflow, Dependabot file, starter code and the
#    language's scripts/check.sh and scripts/setup-worktree.sh);
# 2. appends languages/<language>/gitignore to .gitignore;
# 3. puts languages/<language>/commands.md into AGENTS.md, and
#    languages/<language>/getting-started.md into the new README;
# 4. fills in the placeholders: {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}},
#    {{YEAR}}, and the per-language names derived from the project name
#    ({{PACKAGE_NAME}} for Python and Java packages, {{PASCAL_NAME}} for
#    C# namespaces), in file contents and in paths (__PACKAGE_NAME__,
#    __PASCAL_NAME__), and this year in LICENSE;
# 5. deletes what only the template needs: languages/, the template's own
#    README and CI workflow, and this script.
#
# It changes files only; it doesn't install, commit or push. Review the
# result with `git status` and `git diff`, then follow the steps it prints.
# Undo it before committing with `git restore . && git clean -fd`.
#
# Written for the bash 3.2 that macOS ships, and BSD as well as GNU tools.
#
# Usage: scripts/init-project.sh <typescript|python|java|csharp>
#          [--name <project-name>] [--description "<one paragraph>"]
#   --name defaults to the repository folder's name; lowercase letters,
#   digits and hyphens, starting with a letter. --description is one line
#   without " \ < > or &.
set -euo pipefail

usage() {
  sed -n 's/^# \{0,1\}//; /^Usage:/,/^set /p' "$0" | sed '$d'
  exit "${1:-0}"
}

root="$(cd "$(dirname "$0")/.." && pwd -P)"
cd "$root"

language=""
name=""
description=""
while (($#)); do
  case "$1" in
    -h | --help) usage ;;
    --name) name="${2:?--name needs a value}"; shift 2 ;;
    --description) description="${2:?--description needs a value}"; shift 2 ;;
    -*) echo "unknown option: $1" >&2; usage 2 ;;
    *)
      [[ -z "$language" ]] || { echo "one language only" >&2; usage 2; }
      language="$1"; shift ;;
  esac
done

# Accept the usual short names.
case "$language" in
  ts | typescript) language=typescript ;;
  py | python) language=python ;;
  java) language=java ;;
  cs | csharp | c#) language=csharp ;;
  "") echo "which language? typescript, python, java or csharp" >&2; usage 2 ;;
  *) echo "unknown language: $language (typescript, python, java or csharp)" >&2; exit 2 ;;
esac

lang_dir="$root/languages/$language"
[[ -d "$lang_dir/files" ]] || {
  echo "languages/$language/files/ is missing: has this project been set up already?" >&2
  exit 1
}

name="${name:-$(basename "$root")}"
if ! [[ "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo "project name '$name' must be lowercase letters, digits and hyphens," >&2
  echo "starting with a letter; pass --name <project-name>" >&2
  exit 2
fi
description="${description:-TODO: one paragraph on what this project is and who it is for.}"
# It lands in package.json, pyproject.toml and pom.xml unescaped.
case "$description" in
  *[\"\\\<\>\&]* | *$'\n'*)
    echo 'the description is one line without " \ < > or &' >&2
    exit 2 ;;
esac
year="$(date +%Y)"
# my-app -> my_app (Python and Java packages), MyApp (C# namespaces).
package_name="${name//-/_}"
pascal_name="$(printf '%s' "$name" | awk -F- '{ for (i = 1; i <= NF; i++) printf "%s%s", toupper(substr($i, 1, 1)), substr($i, 2) }')"

echo "setting up $name ($language)"

# 1. The language's files over the root. tar keeps dotfiles and modes.
(cd "$lang_dir/files" && tar -cf - .) | tar -xf -

# 2. Its ignores after the base ones.
if [[ -f "$lang_dir/gitignore" ]]; then
  { echo; cat "$lang_dir/gitignore"; } >>.gitignore
fi

# 3. Its sections into AGENTS.md and the project README. perl rather than
#    sed: the same flags work with BSD and GNU, and the inserted text can
#    hold any character.
insert_file() { # insert_file <target> <marker> <file>
  MARKER="$2" INSERT="$(cat "$3")" perl -0pi -e 's/\Q$ENV{MARKER}\E/$ENV{INSERT}/' "$1"
}
insert_file AGENTS.md "<!-- language:commands -->" "$lang_dir/commands.md"
mv languages/project-README.md README.md
insert_file README.md "<!-- language:getting-started -->" "$lang_dir/getting-started.md"

# 4. Placeholders in paths (deepest first, so a renamed folder doesn't
#    break the paths under it), then in every text file.
find . -depth \( -name '*__PACKAGE_NAME__*' -o -name '*__PASCAL_NAME__*' \) ! -path './.git/*' |
  while IFS= read -r path; do
    base="$(basename "$path")"
    base="${base//__PACKAGE_NAME__/$package_name}"
    base="${base//__PASCAL_NAME__/$pascal_name}"
    mv "$path" "$(dirname "$path")/$base"
  done

export PROJECT_NAME="$name" PROJECT_DESCRIPTION="$description" YEAR="$year" \
  PACKAGE_NAME="$package_name" PASCAL_NAME="$pascal_name"
grep -rlI --exclude-dir=.git --exclude-dir=languages -e '{{[A-Z_]*}}' . |
  while IFS= read -r file; do
    perl -pi -e 's/\{\{(PROJECT_NAME|PROJECT_DESCRIPTION|YEAR|PACKAGE_NAME|PASCAL_NAME)\}\}/$ENV{$1}/g' "$file"
  done
# The license keeps a real year in the template, so GitHub recognises it.
perl -pi -e 's/^(Copyright \(c\) )\d{4}/$1$ENV{YEAR}/' LICENSE

# 5. What only the template needs.
next_steps="$(cat "$lang_dir/next-steps.txt")"
rm -rf languages .github/workflows/template.yml
chmod +x scripts/*.sh
rm -- "$root/scripts/init-project.sh"

cat <<EOF

done. Next:
  1. Review:   git status && git diff
  2. Install and check:
$(printf '%s\n' "$next_steps" | sed 's/^/       /')
       scripts/check.sh
  3. Fill in the TODOs in README.md and AGENTS.md ("What this is").
  4. Commit and push:  git add -A && git commit -m "chore: set up $name from quick-start-repo" && git push
  5. Repository settings and rulesets: docs/github-setup.md
EOF
