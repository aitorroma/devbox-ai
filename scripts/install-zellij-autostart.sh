#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$HOME/.config/zellij/layouts"
cp "$ROOT/config/zellij/layouts/dev.kdl" "$HOME/.config/zellij/layouts/dev.kdl"
SHELL_RC="$HOME/.zshrc"
[[ -n "${BASH_VERSION:-}" && "${SHELL##*/}" == "bash" ]] && SHELL_RC="$HOME/.bashrc"
MARK_START='# >>> vps-cockpit zellij >>>'
MARK_END='# <<< vps-cockpit zellij <<<'
if ! grep -qF "$MARK_START" "$SHELL_RC" 2>/dev/null; then
  cat >> "$SHELL_RC" <<EOF2

$MARK_START
export COCKPIT_HOME="$ROOT"
if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z "\$ZELLIJ" ]] && [[ -z "\$ZELLIJ_AUTO_STARTED" ]] && [[ -z "\$TMUX" ]] && [[ "\$TERM" != "dumb" ]] && command -v devbox >/dev/null 2>&1 && [[ -d "\$COCKPIT_HOME" ]]; then
  export ZELLIJ_AUTO_STARTED=1
  cd "\$COCKPIT_HOME"
  exec devbox run -- zellij attach dev 2>/dev/null || exec devbox run -- zellij --session dev --layout "\$COCKPIT_HOME/config/zellij/layouts/dev.kdl"
fi
$MARK_END
EOF2
  echo "✅ Autostart añadido a $SHELL_RC"
else
  echo "ℹ️  Autostart ya existía en $SHELL_RC"
fi
