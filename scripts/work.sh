#!/usr/bin/env bash
set -euo pipefail

ROOT="${DEVBOX_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
LAYOUT="$ROOT/config/zellij/layouts/dev.kdl"
SESSION="${COCKPIT_ZELLIJ_SESSION:-dev}"
RESET=0

case "${1:-}" in
  --reset|reset)
    RESET=1
    ;;
  -h|--help)
    cat <<HELP
Usage: devbox run work [--reset]

Attach to the cockpit Zellij session, or create it with the portable layout.
Use --reset to kill the existing session first so layout changes apply.
HELP
    exit 0
    ;;
esac

if [[ ! -f "$LAYOUT" ]]; then
  echo "Layout no encontrado: $LAYOUT" >&2
  exit 1
fi

if [[ "$RESET" == 1 ]]; then
  zellij kill-session "$SESSION" >/dev/null 2>&1 || true
fi

if zellij attach "$SESSION" 2>/dev/null; then
  exit 0
fi

exec zellij --session "$SESSION" --new-session-with-layout "$LAYOUT"
