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
  -h, --help         Show this help.

Installs .ai/ context, templates, full standards, and .cursor/ adapters.
Existing files are preserved. Differing files are reported, not upgraded.
No packages are installed and no application code is generated.

Example:
  ./scripts/init-project.sh ../my-app --typescript --react --nestjs
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

while [[ $# -gt 0 ]]; do
  case "$1" in
    --typescript) use_typescript=true ;;
    --react) use_react=true ;;
    --react-native) use_react_native=true ;;
    --nestjs) use_nestjs=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if { [[ "$use_react" == true ]] || [[ "$use_react_native" == true ]] || [[ "$use_nestjs" == true ]]; } && [[ "$use_typescript" != true ]]; then
  echo "React, React Native, and NestJS standards require --typescript." >&2
  exit 1
fi

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

sources=()
destinations=()

queue_copy() {
  sources+=("$system_dir/$1")
  destinations+=("$target_dir/$2")
}

for template in PROJECT ARCHITECTURE STRUCTURE STACK CURRENT; do
  queue_copy "templates/$template.md" ".ai/$template.md"
done

for template_file in "$system_dir"/templates/*.md; do
  queue_copy "templates/$(basename -- "$template_file")" ".ai/templates/$(basename -- "$template_file")"
done

queue_copy "core/core-development.md" ".ai/standards/core/core-development.md"
queue_copy "cursor/rules/00-core.mdc" ".cursor/rules/00-core.mdc"
queue_copy "cursor/rules/01-project-context.mdc" ".cursor/rules/01-project-context.mdc"

if [[ "$use_typescript" == true ]]; then
  queue_copy "frameworks/typescript.md" ".ai/standards/frameworks/typescript.md"
  queue_copy "cursor/rules/10-typescript.mdc" ".cursor/rules/10-typescript.mdc"
fi
if [[ "$use_react" == true || "$use_react_native" == true ]]; then
  queue_copy "frameworks/react.md" ".ai/standards/frameworks/react.md"
fi
if [[ "$use_react" == true ]]; then
  queue_copy "cursor/rules/20-react.mdc" ".cursor/rules/20-react.mdc"
fi
if [[ "$use_react_native" == true ]]; then
  queue_copy "frameworks/react-native.md" ".ai/standards/frameworks/react-native.md"
  queue_copy "cursor/rules/21-react-native.mdc" ".cursor/rules/21-react-native.mdc"
fi
if [[ "$use_nestjs" == true ]]; then
  queue_copy "frameworks/nestjs.md" ".ai/standards/frameworks/nestjs.md"
  queue_copy "cursor/rules/30-nestjs.mdc" ".cursor/rules/30-nestjs.mdc"
fi

for command_file in "$system_dir"/cursor/commands/*.md; do
  queue_copy "cursor/commands/$(basename -- "$command_file")" ".cursor/commands/$(basename -- "$command_file")"
done

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
echo "AI development system initialized in: $target_dir"
if [[ "$different_count" -gt 0 ]]; then
  echo "$different_count existing files differ; this run did not update them."
  echo "Review differences before relying on new rules. See this system's README update instructions."
fi
echo "Next: open the project in Cursor and run /plan-project."
