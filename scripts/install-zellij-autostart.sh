#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$HOME/.config/zellij/layouts"
cp "$ROOT/config/zellij/layouts/dev.kdl" "$HOME/.config/zellij/layouts/dev.kdl"

SHELL_RC="$HOME/.zshrc"
[[ -n "${BASH_VERSION:-}" && "${SHELL##*/}" == "bash" ]] && SHELL_RC="$HOME/.bashrc"

MARK_START='# >>> vps-cockpit zellij >>>'
MARK_END='# <<< vps-cockpit zellij <<<'
BLOCK=$(cat <<EOF2
$MARK_START
export COCKPIT_HOME="$ROOT"
if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z "\$ZELLIJ" ]] && [[ -z "\$ZELLIJ_AUTO_STARTED" ]] && [[ -z "\$TMUX" ]] && [[ "\$TERM" != "dumb" ]] && command -v devbox >/dev/null 2>&1 && [[ -d "\$COCKPIT_HOME" ]]; then
  export ZELLIJ_AUTO_STARTED=1
  cd "\$COCKPIT_HOME"
  exec devbox run -c "\$COCKPIT_HOME" -- work
fi
$MARK_END
EOF2
)

if grep -qF "$MARK_START" "$SHELL_RC" 2>/dev/null; then
  SHELL_RC="$SHELL_RC" MARK_START="$MARK_START" MARK_END="$MARK_END" BLOCK="$BLOCK" python3 - <<'PY'
import os
from pathlib import Path
p = Path(os.environ['SHELL_RC'])
s = p.read_text()
start = os.environ['MARK_START']
end = os.environ['MARK_END']
block = os.environ['BLOCK']
before, rest = s.split(start, 1)
_, after = rest.split(end, 1)
p.write_text(before.rstrip() + "\n\n" + block + after)
PY
  echo "✅ Autostart actualizado en $SHELL_RC"
else
  printf '\n%s\n' "$BLOCK" >> "$SHELL_RC"
  echo "✅ Autostart añadido a $SHELL_RC"
fi
