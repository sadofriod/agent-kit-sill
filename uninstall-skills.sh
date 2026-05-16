#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="${1:-$HOME/.copilot/skills/agent-kit-docs-skill}"

usage() {
  cat <<'EOF'
Usage: ./uninstall-skills.sh [target_dir]

Arguments:
  target_dir
            Installed skill directory to remove.
            Default: ~/.copilot/skills/agent-kit-docs-skill
EOF
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

if [[ ! -e "$TARGET_DIR" ]]; then
  printf 'Nothing to uninstall: %s does not exist.\n' "$TARGET_DIR"
  exit 0
fi

rm -rf "$TARGET_DIR"
printf 'Removed: %s\n' "$TARGET_DIR"