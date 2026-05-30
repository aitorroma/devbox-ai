#!/usr/bin/env bash
set -euo pipefail

PROFILE="${COCKPIT_PROFILE:-base}"
AI="${COCKPIT_ENABLE_AI:-0}"
DEVOPS="${COCKPIT_ENABLE_DEVOPS:-0}"

check() {
  local label="$1"
  shift
  printf '▶ %s\n' "$label"
  "$@"
}

check_shell() {
  local label="$1"
  shift
  printf '▶ %s\n' "$label"
  bash -lc "$*"
}

echo "🩺 Doctor perfil: $PROFILE"

echo
echo "## Base"
check "git" git --version
check_shell "curl" 'curl --version | head -1'
check "zsh" zsh --version
check_shell "nvim" 'nvim --version | head -1'
check_shell "rg" 'rg --version | head -1'
check "fd" fd --version
check_shell "fzf" 'fzf --version | head -1'
check "zoxide" zoxide --version
check "atuin" atuin --version
check "bat" bat --version
check "eza" eza --version
check "carapace" carapace --version
check "python" python3 --version
check "zellij" zellij --version

if [[ "$AI" == "1" ]]; then
  echo
  echo "## IA"
  check "node" node -v
  check "npm" npm -v
  check "pi" pi --version
  check "gentle-ai" gentle-ai --version
  check "codex" codex --version
  check "claude" claude --version
  check "opencode" opencode --version
  check "workmux" workmux --version
  check "rtk" rtk --version
  check "rtk gain" rtk gain
  check "agy" agy --version
else
  echo
  echo "## IA"
  echo "omitido: perfil sin paquetes/agentes IA"
fi

if [[ "$DEVOPS" == "1" ]]; then
  echo
  echo "## DevOps"
  check "jq" jq --version
  check "yq" yq --version
  check_shell "gh" 'gh --version | head -1'
  check "aws" aws --version
  check_shell "gcloud" 'gcloud --version | head -1'
  check "lazygit" lazygit --version
  check "delta" delta --version
  check "duf" duf --version
  check_shell "btop" 'btop --version | head -1'
  check_shell "htop" 'htop --version | head -1'
  check_shell "ncdu" 'ncdu --version | head -1'
  check "tree" tree --version
  check_shell "wget" 'wget --version | head -1'
  check_shell "rsync" 'rsync --version | head -1'
  check "rclone" rclone --version
  check "ngrok" ngrok --version
  check "tmate" tmate -V
  check "asciinema" asciinema --version
  check "openssl" openssl version
  check "age" age --version
  check "sops" sops --version
  check "direnv" direnv --version
  check "just" just --version
  check_shell "make" 'make --version | head -1'
  check_shell "gcc" 'gcc --version | head -1'
  check "pip" pip --version
  check "uv" uv --version
  check "go" go version
  check_shell "rustup" 'rustup --version | head -1'
  check "docker" docker --version
  check "docker-compose" docker-compose --version
  check "helm" helm version --short
  check "kubectl" kubectl version --client=true
  check "k9s" k9s version --short
  check_shell "terraform" 'terraform version | head -1'
  check_shell "tofu" 'tofu version | head -1'
  check_shell "ansible" 'ansible --version | head -1'
  check "http" http --version
  check "xh" xh --version
  check_shell "nmap" 'nmap --version | head -1'
  check "dig" dig -v
  check_shell "whois" 'whois --version | head -1'
  check_shell "tcpdump" 'tcpdump --version | head -1'
  check_shell "mtr" 'mtr --version | head -1'
  check "pre-commit" pre-commit --version
  check_shell "shellcheck" 'shellcheck --version | grep version:'
  check "shfmt" shfmt --version
  check "chezmoi" chezmoi --version
else
  echo
  echo "## DevOps"
  echo "omitido: perfil sin toolpack DevOps"
fi
