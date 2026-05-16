#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_TARGET_DIR="$HOME/.copilot/skills/agent-kit-docs-skill"
TARGET_DIR="$DEFAULT_TARGET_DIR"
INSTALL_MODE="copy"

SKILL_DIRS=(
  "agent-goal-boundary"
  "tool-trigger-contract"
  "shared-state-shaping"
  "deterministic-router-handoff"
  "durable-multistep-tools"
)

ROOT_FILES=(
  "SKILL.md"
  "BOOK_OVERVIEW.md"
  "INDEX.md"
  "verified.md"
)

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: ./install-skills.sh [--link] [target_dir]

Options:
  --link    Install using symbolic links instead of copying files.
  -h, --help
            Show this help message.

Arguments:
  target_dir
            Target installation directory.
            Default: ~/.copilot/skills/agent-kit-docs-skill
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --link)
      INSTALL_MODE="link"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      fail "unknown option: $1"
      ;;
    *)
      [[ "$TARGET_DIR" == "$DEFAULT_TARGET_DIR" ]] || fail "target directory provided more than once"
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

link_item() {
  local source_path="$1"
  local target_path="$2"

  rm -rf "$target_path"
  ln -s "$source_path" "$target_path"
}

printf 'Source: %s\n' "$SCRIPT_DIR"
printf 'Target: %s\n' "$TARGET_DIR"
printf 'Mode: %s\n' "$INSTALL_MODE"

for file in "${ROOT_FILES[@]}"; do
  [[ -f "$SCRIPT_DIR/$file" ]] || fail "missing required file: $file"
done

for dir in "${SKILL_DIRS[@]}"; do
  [[ -f "$SCRIPT_DIR/$dir/SKILL.md" ]] || fail "missing required skill: $dir/SKILL.md"
done

mkdir -p "$TARGET_DIR"

for file in "${ROOT_FILES[@]}"; do
  if [[ "$INSTALL_MODE" == "link" ]]; then
    link_item "$SCRIPT_DIR/$file" "$TARGET_DIR/$file"
  else
    cp "$SCRIPT_DIR/$file" "$TARGET_DIR/$file"
  fi
done

for dir in "${SKILL_DIRS[@]}"; do
  if [[ "$INSTALL_MODE" == "link" ]]; then
    link_item "$SCRIPT_DIR/$dir" "$TARGET_DIR/$dir"
  else
    rm -rf "$TARGET_DIR/$dir"
    cp -R "$SCRIPT_DIR/$dir" "$TARGET_DIR/$dir"
  fi
done

printf '\nInstalled skills:\n'
printf -- '- %s\n' "agent-kit-docs-skill"
for dir in "${SKILL_DIRS[@]}"; do
  printf -- '- %s\n' "$dir"
done

printf '\nInstall complete.\n'