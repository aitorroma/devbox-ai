#!/usr/bin/env bash
set -euo pipefail

ROOT="${COCKPIT_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIG="${COCKPIT_DEVBOX_CONFIG:-${DEVBOX_PROJECT_ROOT:-$ROOT}}"
PROFILE="${COCKPIT_PROFILE:-unknown}"
AI="${COCKPIT_ENABLE_AI:-0}"
DEVOPS="${COCKPIT_ENABLE_DEVOPS:-0}"

cat <<INFO
Perfil cockpit: $PROFILE
Repo:           $ROOT
Devbox config:  $CONFIG
IA:             $AI
DevOps:         $DEVOPS

Perfiles disponibles:
  base    -> shell/cockpit mínimo
  ai      -> base + Node + Pi/gentle-ai/Codex/Claude/OpenCode/Antigravity/Workmux/RTK
  devops  -> base + herramientas DevOps, sin agentes IA
  full    -> ai + devops

Uso diario:
  work --profile ia        # cambia/arranca cockpit IA
  work --profile devops    # cambia/arranca cockpit DevOps
  work --profile full      # cambia/arranca cockpit completo

Actualizar perfil:
  work-update --profile ia
  work-update --profile devops
  work-update --profile full

Bootstrap fresh VPS:
  ./scripts/bootstrap.sh --profile ia
  ./scripts/bootstrap.sh --profile devops
  ./scripts/bootstrap.sh --profile full

Aliases:
  work-ia | work-devops | work-full
  update-ia | update-devops | update-full
INFO
