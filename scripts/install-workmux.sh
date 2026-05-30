#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if [[ "${COCKPIT_ENABLE_AI:-0}" != "1" ]]; then
  echo "ℹ️  Perfil ${COCKPIT_PROFILE:-base}: salto Workmux. Usa perfil ia o full."
  exit 0
fi

echo '🧩 Instalando/actualizando Workmux...'
curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh \
  | WORKMUX_INSTALL_DIR="$HOME/.local/bin" bash

echo '✅ Workmux listo: workmux / wm'
