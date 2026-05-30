#!/usr/bin/env bash
set -euo pipefail

ROOT="${COCKPIT_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck disable=SC1091
source "$ROOT/scripts/profile-utils.sh"
cd "$ROOT"

requested=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      if [[ $# -lt 2 ]]; then
        echo "❌ Falta valor para --profile" >&2
        print_cockpit_profiles_help >&2
        exit 2
      fi
      requested="$2"
      shift 2
      ;;
    --profile=*)
      requested="${1#--profile=}"
      shift
      ;;
    -h|--help)
      cat <<HELP
Usage: ./scripts/bootstrap.sh [--profile ia|devops|full|base]
       ./scripts/bootstrap.sh [ia|devops|full|base]

Fresh VPS installer. Installs Devbox if missing, installs the selected profile,
wires portable shell/Zellij config, and runs AI setup only for ia/full.

Default from base is ia, because it is the canonical AI cockpit.
HELP
      exit 0
      ;;
    *)
      if [[ -z "$requested" ]]; then
        requested="$1"
        shift
      else
        echo "Argumento desconocido: $1" >&2
        exit 2
      fi
      ;;
  esac
done

if [[ -z "$requested" ]]; then
  if [[ "${COCKPIT_PROFILE:-base}" == "base" ]]; then
    requested="ai"
  else
    requested="${COCKPIT_PROFILE:-ai}"
  fi
fi

REQUESTED_RAW="$requested"
if ! requested="$(normalize_cockpit_profile "$REQUESTED_RAW")"; then
  echo "❌ Perfil desconocido: $REQUESTED_RAW" >&2
  print_cockpit_profiles_help >&2
  exit 2
fi

CONFIG_DIR="$(cockpit_profile_config "$ROOT" "$requested")"

if [[ ! -f "$CONFIG_DIR/devbox.json" ]]; then
  echo "❌ No existe devbox.json para el perfil $requested en $CONFIG_DIR" >&2
  exit 1
fi

if ! command -v devbox >/dev/null 2>&1; then
  echo "📦 Instalando Devbox..."
  curl -fsSL https://get.jetify.com/devbox | bash
  export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
fi

if ! command -v devbox >/dev/null 2>&1; then
  echo "❌ Devbox no quedó en PATH. Abre una nueva shell y reintenta." >&2
  exit 1
fi

echo "🚀 Instalando cockpit perfil '$requested'..."
devbox run -c "$CONFIG_DIR" -- setup
devbox run -c "$CONFIG_DIR" -- zsh-install

if [[ "$requested" == "ai" || "$requested" == "full" ]]; then
  devbox run -c "$CONFIG_DIR" -- pi-plugins
  devbox run -c "$CONFIG_DIR" -- mcp-render
else
  echo "ℹ️  Perfil $requested: salto plugins Pi/MCP de IA."
fi

devbox run -c "$CONFIG_DIR" -- zellij-install

echo
if [[ ! -f "$ROOT/.env" && ( "$requested" == "ai" || "$requested" == "full" ) ]]; then
  echo "⚠️  Crea .env cuando tengas tokens: cp .env.example .env && nano .env && devbox run -c '$CONFIG_DIR' -- mcp-render"
fi

echo "✅ Cockpit instalado con perfil '$requested'."
echo "   Config Devbox: $CONFIG_DIR"
echo "   Comandos disponibles tras recargar shell: work, work-reset, work-update, doctor"
if [[ "$requested" == "ai" || "$requested" == "full" ]]; then
  echo "   También: agent, codex, claude, opencode, workmux/wm, rtk gain"
fi
echo "👉 Para entrar ahora: devbox run -c '$CONFIG_DIR' -- work-reset"
if [[ "$requested" == "ai" || "$requested" == "full" ]]; then
  echo "👉 Wizard opcional: devbox run -c '$CONFIG_DIR' -- gentle-install"
fi
