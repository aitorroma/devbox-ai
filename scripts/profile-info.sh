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
  ai      -> base + Node + Pi/gentle-ai/Codex/Claude/Antigravity/RTK
  devops  -> base + herramientas DevOps, sin agentes IA
  full    -> ai + devops

Uso rápido:
  devbox run -c "$ROOT/profiles/ai" -- bootstrap
  devbox run -c "$ROOT/profiles/devops" -- bootstrap
  devbox run -c "$ROOT/profiles/full" -- bootstrap
INFO
