#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install.sh [project-directory] [init-project options]

Downloads the AI development system into a temporary directory and runs
scripts/init-project.sh against the project directory (default: current
directory). The temporary copy is removed afterwards.

Environment:
  AI_DEV_SYSTEM_REPO   Git URL to clone (default: GitHub HTTPS URL).
  AI_DEV_SYSTEM_REF    Branch or tag to install (default: main).

Examples:
  curl -fsSL https://raw.githubusercontent.com/stefanglisic13/ai-development-system/main/scripts/install.sh \
    | bash -s -- --typescript --react --claude

  AI_DEV_SYSTEM_REPO=git@github.com:stefanglisic13/ai-development-system.git \
    bash install.sh ../my-app --typescript --nestjs --cursor --claude
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

repo="${AI_DEV_SYSTEM_REPO:-https://github.com/stefanglisic13/ai-development-system.git}"
ref="${AI_DEV_SYSTEM_REF:-main}"

target="."
if [[ $# -gt 0 && "$1" != -* ]]; then
  target="$1"
  shift
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git is required." >&2
  exit 1
fi

temp_dir="$(mktemp -d)"
trap 'rm -rf -- "$temp_dir"' EXIT

echo "Downloading $repo ($ref)..."
git clone --quiet --depth 1 --branch "$ref" "$repo" "$temp_dir/ai-development-system"

bash "$temp_dir/ai-development-system/scripts/init-project.sh" "$target" "$@"
