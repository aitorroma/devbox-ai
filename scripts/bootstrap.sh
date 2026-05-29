#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v devbox >/dev/null 2>&1; then
  echo "📦 Instalando Devbox..."
  curl -fsSL https://get.jetify.com/devbox | bash
  export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
fi

if ! command -v devbox >/dev/null 2>&1; then
  echo "❌ Devbox no quedó en PATH. Abre una nueva shell y reintenta." >&2
  exit 1
fi

echo "🚀 Instalando cockpit completo..."
devbox run -c "$ROOT" -- setup
devbox run -c "$ROOT" -- zsh-install
devbox run -c "$ROOT" -- pi-plugins
devbox run -c "$ROOT" -- mcp-render
devbox run -c "$ROOT" -- zellij-install

echo
if [[ ! -f "$ROOT/.env" ]]; then
  echo "⚠️  Crea .env cuando tengas tokens: cp .env.example .env && nano .env && devbox run mcp-render"
fi

echo "✅ Cockpit instalado. Comandos disponibles tras recargar shell: work, work-reset, work-update, doctor, agent"
echo "👉 Para entrar ahora: devbox run -c '$ROOT' -- work-reset"
echo "👉 Wizard opcional: devbox run -c '$ROOT' -- gentle-install"
