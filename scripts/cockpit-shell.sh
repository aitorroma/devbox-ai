#!/usr/bin/env bash
set -euo pipefail

ROOT="${DEVBOX_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export COCKPIT_HOME="${COCKPIT_HOME:-$ROOT}"
cd "$COCKPIT_HOME"

if command -v zsh >/dev/null 2>&1; then
  exec zsh -i
fi

exec bash -i
