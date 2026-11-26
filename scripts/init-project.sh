#!/usr/bin/env bash
# Turns a fresh copy of the quick-start-repo template into a project in one
# language. Run it once, in the new repository's root, before the first
# real commit:
#
# 1. copies languages/<language>/files/ over the repository root (its
#    config, CI workflow, Dependabot file, starter code and the
#    language's scripts/check.sh and scripts/setup-worktree.sh), then the
#    files of each choice the language offers (see Choices below);
# 2. appends languages/<language>/gitignore, and each choice's, to
#    .gitignore;
# 3. puts languages/<language>/commands.md into AGENTS.md and
#    languages/<language>/getting-started.md into the new README, then
#    each choice's own commands.md and getting-started.md at its
#    `<!-- option:<kind> -->` marker there, and each choice's snippets at
#    their `option:<snippet>` markers in any file;
# 4. fills in the placeholders: {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}},
#    {{YEAR}}, the per-language names derived from the project name
#    ({{PACKAGE_NAME}} for Python and Java packages, {{PASCAL_NAME}} for
#    C# namespaces) and the chosen options' own (from their `vars`), in
#    file contents and in paths (__PACKAGE_NAME__, __PASCAL_NAME__), and
#    this year in LICENSE;
# 5. deletes what only the template needs: languages/, the template's own
#    README and CI workflow, and this script.
#
# It changes files only; it doesn't install, commit or push. Review the
# result with `git status` and `git diff`, then follow the steps it prints.
# Undo it before committing with `git restore . && git clean -fd`.
#
# Choices: languages/<language>/options/<kind>/ is one setup choice (its
# `question` and `default` files), with a folder per option holding any
# of: `label` (one line for the prompt), `files/`, `gitignore`,
# `commands.md`, `getting-started.md`, `next-steps.txt`, `vars` (NAME=value
# lines, each filling {{NAME}}) and `snippets/<name>` (replaces each line
# that holds `option:<name>`; an empty snippet deletes the line).
#
# Written for the bash 3.2 that macOS ships, and BSD as well as GNU tools.
#
# Usage: scripts/init-project.sh <typescript|python|java|csharp>
#          [--<choice> <option> ...] [--name <project-name>]
#          [--description "<one paragraph>"]
#   Choices: TypeScript --package-manager npm|pnpm|bun and
#   --test vitest|node|jest; Python --typecheck mypy|pyright|ty; Java
#   --build maven|gradle. For a choice left out the script asks, offering
#   the default; when it can't ask (no terminal), it takes the default.
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
# "kind=option" for each --<kind> <option> given. Arrays are expanded as
# ${a[@]+"${a[@]}"}: bash 3.2 calls an empty one unbound under set -u.
given=()
while (($#)); do
  case "$1" in
    -h | --help) usage ;;
    --name) name="${2:?--name needs a value}"; shift 2 ;;
    --description) description="${2:?--description needs a value}"; shift 2 ;;
    --[a-z]*)
      kind="${1#--}"
      [[ "$kind" =~ ^[a-z][a-z-]*$ ]] || { echo "unknown option: $1" >&2; usage 2; }
      given+=("$kind=${2:?$1 needs a value}")
      shift 2 ;;
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

# The language's choices: each kind under options/, its option from the
# command line, the prompt, or its default. `chosen` holds the folders.
options_dir="$lang_dir/options"
kinds=()
if [[ -d "$options_dir" ]]; then
  for dir in "$options_dir"/*/; do kinds+=("$(basename "$dir")"); done
fi
for pair in ${given[@]+"${given[@]}"}; do
  case " ${kinds[*]-} " in
    *" ${pair%%=*} "*) ;;
    *)
      echo "--${pair%%=*} isn't a choice for $language${kinds[0]+ (its choices:$(printf ' --%s' "${kinds[@]}"))}" >&2
      exit 2 ;;
  esac
done
chosen=()
summary=""
for kind in ${kinds[@]+"${kinds[@]}"}; do
  kind_dir="$options_dir/$kind"
  default="$(cat "$kind_dir/default")"
  available=""
  for dir in "$kind_dir"/*/; do available="${available:+$available, }$(basename "$dir")"; done
  option=""
  for pair in ${given[@]+"${given[@]}"}; do
    [[ "${pair%%=*}" != "$kind" ]] || option="${pair#*=}"
  done
  if [[ -z "$option" ]]; then
    if [[ -t 0 ]]; then
      cat "$kind_dir/question"
      for dir in "$kind_dir"/*/; do
        printf '  %-8s %s\n' "$(basename "$dir")" "$(cat "$dir/label")"
      done
      read -r -p "$kind [$default]: " option
    fi
    option="${option:-$default}"
  fi
  [[ -d "$kind_dir/$option" && "$option" != */* && "$option" != .* ]] || {
    echo "unknown $kind: $option (choose from: $available)" >&2
    exit 2
  }
  chosen+=("$kind_dir/$option")
  summary="$summary, $kind $option"
done

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

echo "setting up $name ($language$summary)"

# 1. The language's files over the root, then each choice's. tar keeps
#    dotfiles and modes.
for dir in "$lang_dir" ${chosen[@]+"${chosen[@]}"}; do
  if [[ -d "$dir/files" ]]; then
    (cd "$dir/files" && tar -cf - .) | tar -xf -
  fi
done

# 2. Their ignores after the base ones.
for dir in "$lang_dir" ${chosen[@]+"${chosen[@]}"}; do
  if [[ -f "$dir/gitignore" ]]; then
    { echo; cat "$dir/gitignore"; } >>.gitignore
  fi
done

# 3. Its sections into AGENTS.md and the project README. perl rather than
#    sed: the same flags work with BSD and GNU, and the inserted text can
#    hold any character.
insert_file() { # insert_file <target> <marker> <file>
  MARKER="$2" INSERT="$(cat "$3")" perl -0pi -e 's/\Q$ENV{MARKER}\E/$ENV{INSERT}/' "$1"
}
insert_file AGENTS.md "<!-- language:commands -->" "$lang_dir/commands.md"
mv languages/project-README.md README.md
insert_file README.md "<!-- language:getting-started -->" "$lang_dir/getting-started.md"
for dir in ${chosen[@]+"${chosen[@]}"}; do
  marker="<!-- option:$(basename "$(dirname "$dir")") -->"
  [[ ! -f "$dir/commands.md" ]] || insert_file AGENTS.md "$marker" "$dir/commands.md"
  [[ ! -f "$dir/getting-started.md" ]] || insert_file README.md "$marker" "$dir/getting-started.md"
done
# A marker no choice filled goes, line and all.
perl -ni -e 'print unless /^<!-- option:[a-z-]+ -->$/' AGENTS.md README.md
for dir in ${chosen[@]+"${chosen[@]}"}; do
  [[ -d "$dir/snippets" ]] || continue
  for snippet in "$dir"/snippets/*; do
    marker="option:$(basename "$snippet")"
    grep -rlIF --exclude-dir=.git --exclude-dir=languages -e "$marker" . |
      while IFS= read -r file; do
        MARKER="$marker" INSERT="$(cat "$snippet"; echo x)" \
          perl -0pi -e '$i = substr($ENV{INSERT}, 0, -1); s/^[^\n]*\Q$ENV{MARKER}\E(?![\w-])[^\n]*\n/$i/mg' "$file"
      done
  done
done

# 4. Placeholders in paths (deepest first, so a renamed folder doesn't
#    break the paths under it), then in every text file.
find . -depth \( -name '*__PACKAGE_NAME__*' -o -name '*__PASCAL_NAME__*' \) ! -path './.git/*' |
  while IFS= read -r path; do
    base="$(basename "$path")"
    base="${base//__PACKAGE_NAME__/$package_name}"
    base="${base//__PASCAL_NAME__/$pascal_name}"
    mv "$path" "$(dirname "$path")/$base"
  done

# Every value goes in the environment as QSR_<NAME>; a {{NAME}} with none
# stays, for the template's CI to catch.
export QSR_PROJECT_NAME="$name" QSR_PROJECT_DESCRIPTION="$description" \
  QSR_YEAR="$year" QSR_PACKAGE_NAME="$package_name" QSR_PASCAL_NAME="$pascal_name"
for dir in ${chosen[@]+"${chosen[@]}"}; do
  [[ -f "$dir/vars" ]] || continue
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -n "$line" && "$line" != \#* ]] || continue
    key="${line%%=*}"
    [[ "$key" =~ ^[A-Z][A-Z_]*$ && "$line" == *=* ]] || {
      echo "bad line in ${dir#"$root"/}/vars: $line" >&2
      exit 1
    }
    export "QSR_$key=${line#*=}"
  done <"$dir/vars"
done
# Perl, not shell, expands $ENV and $1 here.
# shellcheck disable=SC2016
fill='s/\{\{([A-Z][A-Z_]*)\}\}/exists $ENV{"QSR_$1"} ? $ENV{"QSR_$1"} : $&/ge'
grep -rlI --exclude-dir=.git --exclude-dir=languages -e '{{[A-Z_]*}}' . |
  while IFS= read -r file; do
    perl -pi -e "$fill" "$file"
  done
# The license keeps a real year in the template, so GitHub recognises it.
perl -pi -e 's/^(Copyright \(c\) )\d{4}/$1$ENV{QSR_YEAR}/' LICENSE

# 5. What only the template needs.
next_steps=""
for dir in "$lang_dir" ${chosen[@]+"${chosen[@]}"}; do
  [[ ! -f "$dir/next-steps.txt" ]] || next_steps="${next_steps:+$next_steps$'\n'}$(cat "$dir/next-steps.txt")"
done
next_steps="$(printf '%s\n' "$next_steps" | perl -pe "$fill")"
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
