#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if command -v agy >/dev/null 2>&1; then
  echo "✅ Antigravity CLI ya está instalado: $(agy --version 2>/dev/null || echo agy)"
  echo "   El binario se auto-actualiza durante el uso normal."
  exit 0
fi

echo "🛰️  Instalando Antigravity CLI (agy)..."
echo "   Fuente oficial: https://antigravity.google/cli/install.sh"

curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir "$HOME/.local/bin"

if ! command -v agy >/dev/null 2>&1; then
  echo "❌ agy no quedó en PATH. Revisa que $HOME/.local/bin esté en PATH." >&2
  exit 1
fi

echo "✅ Antigravity CLI listo: $(agy --version 2>/dev/null || echo agy)"
echo "👉 Ejecuta 'agy' para iniciar sesión. En SSH imprimirá una URL de autorización."
