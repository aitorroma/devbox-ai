#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSHRC="$HOME/.zshrc"
P10K="$HOME/.p10k.zsh"
STAMP="$(date +%Y%m%d%H%M%S)"

mkdir -p "$HOME/.cache/zsh"

if [[ -f "$ZSHRC" ]] && ! grep -q 'vps-cockpit zsh' "$ZSHRC"; then
  cp "$ZSHRC" "$ZSHRC.bak.$STAMP"
  echo "ℹ️  Backup: $ZSHRC.bak.$STAMP"
fi

sed "s#__COCKPIT_HOME__#$ROOT#g" "$ROOT/config/zsh/zshrc" > "$ZSHRC"
cp "$ROOT/config/zsh/p10k.zsh" "$P10K"

if command -v zsh >/dev/null 2>&1; then
  echo "✅ Zsh cockpit instalado en $ZSHRC"
  echo "   Prueba: devbox run -c '$ROOT' -- zsh -i"
else
  echo "⚠️  zsh no está en PATH todavía. Entra con: devbox shell"
fi
