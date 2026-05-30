#!/usr/bin/env bash
set -euo pipefail

ROOT="${COCKPIT_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIG_DIR="${COCKPIT_DEVBOX_CONFIG:-${DEVBOX_PROJECT_ROOT:-$ROOT}}"
cd "$ROOT"

echo "🔄 Actualizando cockpit en $ROOT"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git pull --ff-only
else
  echo "⚠️  No es un repo git: salto git pull"
fi

if [[ "${COCKPIT_ENABLE_AI:-0}" == "1" ]]; then
  echo "🤖 Actualizando AI CLIs..."
  "$ROOT/scripts/install-ai-clis.sh"

  echo "🪓 Actualizando RTK..."
  "$ROOT/scripts/install-rtk.sh"

  echo "🛰️  Actualizando Antigravity CLI..."
  "$ROOT/scripts/install-antigravity.sh"
else
  echo "ℹ️  Perfil ${COCKPIT_PROFILE:-base}: salto AI CLIs/RTK/Antigravity."
fi

echo "🐚 Instalando zsh portable..."
"$ROOT/scripts/install-zsh.sh"

echo "🧩 Instalando autostart/aliases..."
"$ROOT/scripts/install-zellij-autostart.sh"

if [[ -n "${ZELLIJ:-}" ]]; then
  echo "⚠️  Actualización instalada. Estás dentro de Zellij, así que no mato esta sesión desde dentro."
  echo "   Sal/desconecta y entra de nuevo, o desde una shell fuera de Zellij ejecuta:"
  echo "   devbox run -c '$CONFIG_DIR' -- work-reset"
  exit 0
fi

echo "🚀 Recreando workspace Zellij..."
exec "$ROOT/scripts/work.sh" --reset
