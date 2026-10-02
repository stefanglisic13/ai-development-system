#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/init-project.sh <project-directory> [options]

Options:
  --typescript       Add the TypeScript Cursor rule.
  --react            Add the React web Cursor rule. Requires --typescript.
  --react-native     Add the React Native and Expo Cursor rule. Requires --typescript.
  --nestjs           Add the NestJS Cursor rule. Requires --typescript.
  -h, --help         Show this help.

The command initializes .ai/ project context and .cursor/ rules and commands.
It never overwrites an existing file.

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

target_input="$1"
shift

if [[ ! -d "$target_input" ]]; then
  echo "Project directory does not exist: $target_input" >&2
  exit 1
fi

target_dir="$(cd "$target_input" && pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

use_typescript=false
use_react=false
use_react_native=false
use_nestjs=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --typescript)
      use_typescript=true
      ;;
    --react)
      use_react=true
      ;;
    --react-native)
      use_react_native=true
      ;;
    --nestjs)
      use_nestjs=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac

  shift
done

if { [[ "$use_react" == true ]] || [[ "$use_react_native" == true ]] || [[ "$use_nestjs" == true ]]; } && [[ "$use_typescript" != true ]]; then
  echo "React, React Native, and NestJS standards require --typescript." >&2
  exit 1
fi

copy_if_missing() {
  local source_file="$1"
  local target_file="$2"

  if [[ -e "$target_file" ]]; then
    echo "Skipped existing: ${target_file#$target_dir/}"
    return
  fi

  mkdir -p "$(dirname "$target_file")"
  cp "$source_file" "$target_file"
  echo "Created: ${target_file#$target_dir/}"
}

mkdir -p \
  "$target_dir/.ai/decisions" \
  "$target_dir/.ai/features" \
  "$target_dir/.ai/templates" \
  "$target_dir/.cursor/commands" \
  "$target_dir/.cursor/rules"

copy_if_missing "$script_dir/templates/PROJECT.md" "$target_dir/.ai/PROJECT.md"
copy_if_missing "$script_dir/templates/ARCHITECTURE.md" "$target_dir/.ai/ARCHITECTURE.md"
copy_if_missing "$script_dir/templates/STRUCTURE.md" "$target_dir/.ai/STRUCTURE.md"
copy_if_missing "$script_dir/templates/STACK.md" "$target_dir/.ai/STACK.md"
copy_if_missing "$script_dir/templates/CURRENT.md" "$target_dir/.ai/CURRENT.md"
copy_if_missing "$script_dir/templates/ADR.md" "$target_dir/.ai/templates/ADR.md"
copy_if_missing "$script_dir/templates/FEATURE.md" "$target_dir/.ai/templates/FEATURE.md"
copy_if_missing "$script_dir/templates/PLAN.md" "$target_dir/.ai/templates/PLAN.md"

copy_if_missing "$script_dir/cursor/rules/00-core.mdc" "$target_dir/.cursor/rules/00-core.mdc"
copy_if_missing "$script_dir/cursor/rules/01-project-context.mdc" "$target_dir/.cursor/rules/01-project-context.mdc"

if [[ "$use_typescript" == true ]]; then
  copy_if_missing "$script_dir/cursor/rules/10-typescript.mdc" "$target_dir/.cursor/rules/10-typescript.mdc"
fi

if [[ "$use_react" == true ]]; then
  copy_if_missing "$script_dir/cursor/rules/20-react.mdc" "$target_dir/.cursor/rules/20-react.mdc"
fi

if [[ "$use_react_native" == true ]]; then
  copy_if_missing "$script_dir/cursor/rules/21-react-native.mdc" "$target_dir/.cursor/rules/21-react-native.mdc"
fi

if [[ "$use_nestjs" == true ]]; then
  copy_if_missing "$script_dir/cursor/rules/30-nestjs.mdc" "$target_dir/.cursor/rules/30-nestjs.mdc"
fi

for command_file in "$script_dir"/cursor/commands/*.md; do
  copy_if_missing "$command_file" "$target_dir/.cursor/commands/$(basename "$command_file")"
done

echo
echo "AI development system initialized in: $target_dir"
echo "Next: open the project in Cursor and run /plan-project."
