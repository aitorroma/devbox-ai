#!/usr/bin/env bash
set -euo pipefail

if [[ "${COCKPIT_ENABLE_AI:-0}" != "1" ]]; then
  echo "ℹ️  Perfil ${COCKPIT_PROFILE:-base}: sin agentes IA. Salto plugins Pi."
  exit 0
fi
echo '🔌 Instalando plugins Pi/gentle...'
pi install npm:gentle-pi
pi install npm:pi-mcp-adapter
npm exec --yes --package gentle-engram@latest -- pi-engram init
pi install npm:pi-subagents
pi install npm:pi-intercom
pi install npm:pi-web-access
pi install npm:pi-lens
pi install npm:pi-btw
echo '✅ Plugins listos'
