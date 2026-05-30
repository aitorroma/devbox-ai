#!/usr/bin/env bash
set -euo pipefail

ROOT="${COCKPIT_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
source "$ROOT/scripts/profile-utils.sh"
CONFIG_DIR="${COCKPIT_DEVBOX_CONFIG:-${DEVBOX_PROJECT_ROOT:-$ROOT}}"
PROFILE_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
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
      cat <<HELP
Usage: work-update [--profile ia|devops|full|base]

Pull the latest repo changes, reinstall portable shell/Zellij wiring, update
profile-specific tools, and recreate the cockpit when safe.

Examples:
  work-update --profile ia
  work-update --profile devops
  work-update --profile full
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
    echo "🔁 Actualizando con perfil '$TARGET_PROFILE'..."
    exec devbox run -c "$TARGET_CONFIG" -- bash "$ROOT/scripts/work-update.sh"
  fi
fi

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

  echo "🧩 Actualizando Workmux..."
  "$ROOT/scripts/install-workmux.sh"
else
  echo "ℹ️  Perfil ${COCKPIT_PROFILE:-base}: salto AI CLIs/RTK/Antigravity/Workmux."
fi

echo "🐚 Instalando zsh portable..."
"$ROOT/scripts/install-zsh.sh"

echo "🧩 Instalando autostart/aliases..."
"$ROOT/scripts/install-zellij-autostart.sh"

if [[ -n "${ZELLIJ:-}" ]]; then
  echo "⚠️  Actualización instalada. Estás dentro de Zellij, así que no mato esta sesión desde dentro."
  echo "   Sal/desconecta y entra de nuevo, o desde una shell fuera de Zellij ejecuta:"
  echo "   devbox run -c '$CONFIG_DIR' -- bash '$ROOT/scripts/work.sh' --reset"
  exit 0
fi

echo "🚀 Recreando workspace Zellij..."
exec devbox run -c "$CONFIG_DIR" -- bash "$ROOT/scripts/work.sh" --reset
