#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="${COCKPIT_DEVBOX_CONFIG:-${DEVBOX_PROJECT_ROOT:-$ROOT}}"
PROFILE="${COCKPIT_PROFILE:-base}"
ZSHRC="$HOME/.zshrc"
STAMP="$(date +%Y%m%d%H%M%S)"

mkdir -p "$HOME/.cache/zsh"

if [[ -f "$ZSHRC" ]] && ! grep -q 'vps-cockpit zsh' "$ZSHRC"; then
  cp "$ZSHRC" "$ZSHRC.bak.$STAMP"
  echo "ℹ️  Backup: $ZSHRC.bak.$STAMP"
fi

sed -e "s#__COCKPIT_HOME__#$ROOT#g" \
    -e "s#__COCKPIT_DEVBOX_CONFIG__#$CONFIG_DIR#g" \
    -e "s#__COCKPIT_PROFILE__#$PROFILE#g" \
    "$ROOT/config/zsh/zshrc" > "$ZSHRC"
if command -v zsh >/dev/null 2>&1; then
  echo "✅ Zsh cockpit instalado en $ZSHRC"
  echo "   Prueba: devbox run -c '$CONFIG_DIR' -- zsh -i"
else
  echo "⚠️  zsh no está en PATH todavía. Entra con: devbox shell"
fi
