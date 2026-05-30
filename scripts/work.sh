#!/usr/bin/env bash
set -euo pipefail

ROOT="${COCKPIT_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
source "$ROOT/scripts/profile-utils.sh"
CONFIG_DIR="${COCKPIT_DEVBOX_CONFIG:-${DEVBOX_PROJECT_ROOT:-$ROOT}}"
TEMPLATE="$ROOT/config/zellij/layouts/dev.kdl.template"
LAYOUT="$ROOT/.devbox/gen/zellij-dev.kdl"
SESSION="${COCKPIT_ZELLIJ_SESSION:-dev}"
RESET=0
PROFILE_OVERRIDE=""
FORWARD_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --reset|reset)
      RESET=1
      FORWARD_ARGS+=("--reset")
      shift
      ;;
    --profile)
      if [[ $# -lt 2 ]]; then
        echo "❌ Falta valor para --profile" >&2
        print_cockpit_profiles_help >&2
        exit 2
      fi
      PROFILE_OVERRIDE="$2"
      shift 2
      ;;
    --profile=*)
      PROFILE_OVERRIDE="${1#--profile=}"
      shift
      ;;
    -h|--help)
      cat <<'HELP'
Usage: work [--profile ia|devops|full|base] [--reset]

Attach to the cockpit Zellij session, or create it with the portable layout.
Use --profile to switch profiles before launching. `ia` and `ai` are aliases.
Use --reset to delete the existing session first so tab/layout changes apply.

Examples:
  work --profile ia
  work --profile devops --reset
  work --profile full

Layout:
  SYSTEM: one full-screen shell in $HOME
  IA:     three-pane AI cockpit in the repo
HELP
      exit 0
      ;;
    *)
      echo "Argumento desconocido: $1" >&2
      exit 2
      ;;
  esac
done

if [[ -n "$PROFILE_OVERRIDE" ]]; then
  if ! TARGET_PROFILE="$(normalize_cockpit_profile "$PROFILE_OVERRIDE")"; then
    echo "❌ Perfil desconocido: $PROFILE_OVERRIDE" >&2
    print_cockpit_profiles_help >&2
    exit 2
  fi
  TARGET_CONFIG="$(cockpit_profile_config "$ROOT" "$TARGET_PROFILE")"
  if [[ ! -f "$TARGET_CONFIG/devbox.json" ]]; then
    echo "❌ No existe devbox.json para el perfil $TARGET_PROFILE en $TARGET_CONFIG" >&2
    exit 1
  fi
  if [[ "$TARGET_CONFIG" != "$CONFIG_DIR" ]]; then
    echo "🔁 Cambiando a perfil '$TARGET_PROFILE'..."
    exec devbox run -c "$TARGET_CONFIG" -- bash "$ROOT/scripts/work.sh" "${FORWARD_ARGS[@]}"
  fi
fi

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template de layout no encontrado: $TEMPLATE" >&2
  exit 1
fi

mkdir -p "$(dirname "$LAYOUT")"
ROOT="$ROOT" HOME_DIR="$HOME" TEMPLATE="$TEMPLATE" LAYOUT="$LAYOUT" python3 - <<'PY'
import json
import os
from pathlib import Path

def kdl_string(value: str) -> str:
    return json.dumps(value)

template = Path(os.environ['TEMPLATE']).read_text()
rendered = template.replace('"__ROOT__"', kdl_string(os.environ['ROOT']))
rendered = rendered.replace('"__HOME__"', kdl_string(os.environ['HOME_DIR']))
Path(os.environ['LAYOUT']).write_text(rendered)
PY

cd "$ROOT"

# Use normal terminal panes, not command panes. Zellij opens $SHELL for bare panes.
if command -v zsh >/dev/null 2>&1; then
  export SHELL="$(command -v zsh)"
else
  export SHELL="$(command -v bash)"
fi
export COCKPIT_HOME="${COCKPIT_HOME:-$ROOT}"

if [[ -n "${ZELLIJ:-}" ]]; then
  if [[ "$RESET" == 1 ]]; then
    cat >&2 <<MSG
⚠️  Estás dentro de Zellij. No ejecuto work-reset desde dentro porque Zellij
   puede interpretar la creación de layout como una tab nueva.

   Hazlo desde fuera de Zellij:
     ZELLIJ_AUTO_STARTED=1 bash -lc 'cd "$ROOT" && devbox run -c "$CONFIG_DIR" -- bash "$ROOT/scripts/work.sh" --reset'
MSG
    exit 2
  fi
  echo "ℹ️  Ya estás dentro de Zellij. Usa Ctrl+o d para detach o work-reset desde fuera."
  exit 0
fi

if [[ "$RESET" == 1 ]]; then
  # Delete removes EXITED/resurrectable sessions too; --force kills if still running.
  zellij delete-session --force "$SESSION" >/dev/null 2>&1 || true
fi

if zellij attach "$SESSION" 2>/dev/null; then
  exit 0
fi

exec zellij --session "$SESSION" --new-session-with-layout "$LAYOUT"
