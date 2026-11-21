#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/init-project.sh <existing-project-directory> [options]

Options:
  --typescript       Include the TypeScript standard.
  --react            Include React web (requires --typescript).
  --react-native     Include React Native/Expo and shared React principles
                     (requires --typescript).
  --nestjs           Include NestJS (requires --typescript).
  --update           Upgrade system-owned files to this version.
  -h, --help         Show this help.

Installs .ai/ context, templates, framework standards, and the Claude Code
rules, commands, and settings in .claude/.

Without --update, existing files are preserved and differing files reported.
With --update, system-owned files (rules, commands, .ai/standards/,
.ai/templates/) are overwritten; the installed stack is detected, so no other
option is needed. Project-owned files (.ai/*.md, features, decisions,
.claude/settings.json) are never overwritten. No packages are installed and
no code is generated.

Example:
  ./scripts/init-project.sh ../my-app --typescript --react --nestjs
  ./scripts/init-project.sh ../my-app --update
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "$1" == -* ]]; then
  echo "Project directory must be the first argument." >&2
  usage
  exit 1
fi

target_input="$1"
shift

use_typescript=false
use_react=false
use_react_native=false
use_nestjs=false
update=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --typescript) use_typescript=true ;;
    --react) use_react=true ;;
    --react-native) use_react_native=true ;;
    --nestjs) use_nestjs=true ;;
    --update) update=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if [[ ! -d "$target_input" ]]; then
  echo "Project directory does not exist: $target_input" >&2
  exit 1
fi

target_dir="$(cd -- "$target_input" && pwd -P)"
system_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"

if [[ "$target_dir" == "/" || "$target_dir" == "$HOME" || "$target_dir" == "$system_dir" ]]; then
  echo "Choose a concrete application project, not the system repository or a broad root." >&2
  exit 1
fi

# With --update, add whatever is already installed to the requested options.
if [[ "$update" == true ]]; then
  rules_dir="$target_dir/.claude/rules"
  if [[ ! -f "$rules_dir/01-project-context.md" ]]; then
    echo "No installation found to update in: $target_dir" >&2
    exit 1
  fi
  if [[ -f "$rules_dir/10-typescript.md" ]]; then use_typescript=true; fi
  if [[ -f "$rules_dir/20-react.md" ]]; then use_react=true; fi
  if [[ -f "$rules_dir/21-react-native.md" ]]; then use_react_native=true; fi
  if [[ -f "$rules_dir/30-nestjs.md" ]]; then use_nestjs=true; fi
fi

if { [[ "$use_react" == true ]] || [[ "$use_react_native" == true ]] || [[ "$use_nestjs" == true ]]; } && [[ "$use_typescript" != true ]]; then
  echo "React, React Native, and NestJS standards require --typescript." >&2
  exit 1
fi

sources=()
destinations=()
owners=()

# queue_copy <source in this repo> <destination in the project> <system|project>
queue_copy() {
  sources+=("$system_dir/$1")
  destinations+=("$target_dir/$2")
  owners+=("$3")
}

for template in PROJECT ARCHITECTURE STRUCTURE STACK CURRENT; do
  queue_copy "templates/$template.md" ".ai/$template.md" project
done

for template_file in "$system_dir"/templates/*.md; do
  queue_copy "templates/$(basename -- "$template_file")" ".ai/templates/$(basename -- "$template_file")" system
done

if [[ "$use_typescript" == true ]]; then
  queue_copy "frameworks/typescript.md" ".ai/standards/frameworks/typescript.md" system
fi
if [[ "$use_react" == true || "$use_react_native" == true ]]; then
  queue_copy "frameworks/react.md" ".ai/standards/frameworks/react.md" system
fi
if [[ "$use_react_native" == true ]]; then
  queue_copy "frameworks/react-native.md" ".ai/standards/frameworks/react-native.md" system
fi
if [[ "$use_nestjs" == true ]]; then
  queue_copy "frameworks/nestjs.md" ".ai/standards/frameworks/nestjs.md" system
fi

# The core standard is installed as the always-loaded rule 00-core.
queue_copy "core/core-development.md" ".claude/rules/00-core.md" system
queue_copy "claude/rules/01-project-context.md" ".claude/rules/01-project-context.md" system
if [[ "$use_typescript" == true ]]; then
  queue_copy "claude/rules/10-typescript.md" ".claude/rules/10-typescript.md" system
fi
if [[ "$use_react" == true ]]; then
  queue_copy "claude/rules/20-react.md" ".claude/rules/20-react.md" system
fi
if [[ "$use_react_native" == true ]]; then
  queue_copy "claude/rules/21-react-native.md" ".claude/rules/21-react-native.md" system
fi
if [[ "$use_nestjs" == true ]]; then
  queue_copy "claude/rules/30-nestjs.md" ".claude/rules/30-nestjs.md" system
fi
for command_file in "$system_dir"/claude/commands/*.md; do
  queue_copy "claude/commands/$(basename -- "$command_file")" ".claude/commands/$(basename -- "$command_file")" system
done
# Asks for confirmation before package installs. Project-owned once created.
queue_copy "claude/settings.json" ".claude/settings.json" project

# Preflight every destination before making any changes.
check_directory_path() {
  local directory="$1"
  while [[ "$directory" != "$target_dir" ]]; do
    if [[ -L "$directory" || ( -e "$directory" && ! -d "$directory" ) ]]; then
      echo "Unsupported destination directory (symlink or non-directory): $directory" >&2
      exit 1
    fi
    directory="$(dirname -- "$directory")"
  done
}

check_directory_path "$target_dir/.ai/features"
check_directory_path "$target_dir/.ai/decisions"
for ((i = 0; i < ${#sources[@]}; i++)); do
  source_file="${sources[$i]}"
  target_file="${destinations[$i]}"
  if [[ ! -f "$source_file" ]]; then
    echo "Missing source: $source_file" >&2
    exit 1
  fi
  check_directory_path "$(dirname -- "$target_file")"
  if [[ -L "$target_file" || ( -e "$target_file" && ! -f "$target_file" ) ]]; then
    echo "Unsupported destination file (symlink or non-file): $target_file" >&2
    exit 1
  fi
done

mkdir -p "$target_dir/.ai/features" "$target_dir/.ai/decisions"
different_count=0
for ((i = 0; i < ${#sources[@]}; i++)); do
  source_file="${sources[$i]}"
  target_file="${destinations[$i]}"
  if [[ -f "$target_file" ]]; then
    if cmp -s "$source_file" "$target_file"; then
      echo "Unchanged: ${target_file#$target_dir/}"
    elif [[ "$update" == true && "${owners[$i]}" == system ]]; then
      cp "$source_file" "$target_file"
      echo "Updated: ${target_file#$target_dir/}"
    elif [[ "${owners[$i]}" == project ]]; then
      echo "Project-owned, kept: ${target_file#$target_dir/}"
    else
      echo "Preserved differing file: ${target_file#$target_dir/}"
      different_count=$((different_count + 1))
    fi
    continue
  fi
  mkdir -p "$(dirname -- "$target_file")"
  cp -n "$source_file" "$target_file"
  echo "Created: ${target_file#$target_dir/}"
done

echo
if [[ "$update" == true ]]; then
  echo "AI development system updated in: $target_dir"
  echo "Review the diff. Project documents were not changed; align them with .ai/templates/ where needed."
  exit 0
fi
echo "AI development system initialized in: $target_dir"
if [[ "$different_count" -gt 0 ]]; then
  echo "$different_count system files differ from this version."
  echo "Rerun with --update to upgrade them; project documents are never overwritten."
fi
echo "Next: run claude in the project root and run /plan-project."
