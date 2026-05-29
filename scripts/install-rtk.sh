#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if command -v rtk >/dev/null 2>&1 && rtk gain >/dev/null 2>&1; then
  echo "✅ RTK ya está instalado: $(rtk --version)"
else
  echo "🪓 Instalando RTK (Rust Token Killer) desde rtk-ai/rtk..."
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
fi

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if ! command -v rtk >/dev/null 2>&1; then
  echo "❌ RTK no quedó en PATH. Revisa que $HOME/.local/bin esté en PATH." >&2
  exit 1
fi

if ! rtk gain >/dev/null 2>&1; then
  echo "❌ 'rtk gain' falló. Puede que se haya instalado otro rtk; usa rtk-ai/rtk." >&2
  exit 1
fi

echo "✅ RTK listo: $(rtk --version)"

if [[ "${RTK_SKIP_INIT:-0}" == "1" ]]; then
  echo "ℹ️  RTK_SKIP_INIT=1: no configuro hooks de agentes."
  exit 0
fi

echo "🪝 Configurando hooks globales RTK para Claude/Copilot..."
rtk init -g || echo "⚠️  No pude configurar hook Claude/Copilot automáticamente; ejecuta: rtk init -g"

echo "🪝 Configurando hooks globales RTK para Codex..."
rtk init -g --codex || echo "⚠️  No pude configurar hook Codex automáticamente; ejecuta: rtk init -g --codex"

echo "📊 Verificación: rtk gain"
rtk gain || true
