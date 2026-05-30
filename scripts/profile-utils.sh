#!/usr/bin/env bash
# Shared helpers for cockpit profile selection.

normalize_cockpit_profile() {
  case "${1:-}" in
    ""|base) printf 'base' ;;
    ai|ia|AI|IA) printf 'ai' ;;
    devops|ops) printf 'devops' ;;
    full|todo|all) printf 'full' ;;
    *) return 1 ;;
  esac
}

cockpit_profile_config() {
  local root="$1"
  local profile="$2"
  case "$profile" in
    base) printf '%s' "$root" ;;
    ai|devops|full) printf '%s/profiles/%s' "$root" "$profile" ;;
    *) return 1 ;;
  esac
}

current_cockpit_profile() {
  normalize_cockpit_profile "${COCKPIT_PROFILE:-base}" || printf 'base'
}

print_cockpit_profiles_help() {
  cat <<'HELP'
Perfiles válidos:
  base    -> cockpit/shell mínimo
  ia|ai   -> base + agentes IA (Pi, Codex, Claude, Antigravity, RTK)
  devops  -> base + herramientas DevOps/infra
  full    -> ia + devops
HELP
}
