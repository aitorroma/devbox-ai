#!/usr/bin/env bash
set -euo pipefail

ROOT="${DEVBOX_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
cd "$ROOT"

echo "🔄 Actualizando cockpit en $ROOT"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git pull --ff-only
else
  echo "⚠️  No es un repo git: salto git pull"
fi

echo "🤖 Actualizando AI CLIs..."
"$ROOT/scripts/install-ai-clis.sh"

echo "🐚 Instalando zsh portable..."
"$ROOT/scripts/install-zsh.sh"

echo "🧩 Instalando autostart/aliases..."
"$ROOT/scripts/install-zellij-autostart.sh"

if [[ -n "${ZELLIJ:-}" ]]; then
  echo "⚠️  Actualización instalada. Estás dentro de Zellij, así que no mato esta sesión desde dentro."
  echo "   Sal/desconecta y entra de nuevo, o desde una shell fuera de Zellij ejecuta:"
  echo "   devbox run -c '$ROOT' -- work-reset"
  exit 0
fi

echo "🚀 Recreando workspace Zellij..."
exec "$ROOT/scripts/work.sh" --reset
