#!/usr/bin/env bash
set -euo pipefail

ROOT="${DEVBOX_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
LAYOUT="$ROOT/config/zellij/layouts/dev.kdl"
SESSION="${COCKPIT_ZELLIJ_SESSION:-dev}"

if [[ ! -f "$LAYOUT" ]]; then
  echo "Layout no encontrado: $LAYOUT" >&2
  exit 1
fi

if zellij attach "$SESSION" 2>/dev/null; then
  exit 0
fi

exec zellij --session "$SESSION" --new-session-with-layout "$LAYOUT"
