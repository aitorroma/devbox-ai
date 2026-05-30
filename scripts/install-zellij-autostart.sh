#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="${COCKPIT_DEVBOX_CONFIG:-${DEVBOX_PROJECT_ROOT:-$ROOT}}"
PROFILE="${COCKPIT_PROFILE:-base}"
mkdir -p "$HOME/.config/zellij/layouts"
cp "$ROOT/config/zellij/layouts/dev.kdl.template" "$HOME/.config/zellij/layouts/dev.kdl.template"

MARK_START='# >>> vps-cockpit zellij >>>'
MARK_END='# <<< vps-cockpit zellij <<<'
BLOCK=$(cat <<EOF2
$MARK_START
export COCKPIT_HOME="$ROOT"
export COCKPIT_DEVBOX_CONFIG="$CONFIG_DIR"
export COCKPIT_PROFILE="$PROFILE"
alias work='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh"'
alias work-reset='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh" --reset'
alias work-ia='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh" --profile ia'
alias work-ai='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh" --profile ia'
alias work-devops='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh" --profile devops'
alias work-full='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh" --profile full'
alias work-update='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work-update.sh"'
alias update-ia='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work-update.sh" --profile ia'
alias update-ai='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work-update.sh" --profile ia'
alias update-devops='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work-update.sh" --profile devops'
alias update-full='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work-update.sh" --profile full'
alias doctor='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- doctor'
alias profile-info='devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- profile-info'
opencode() { devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash -lc 'opencode "\$@"' _ "\$@"; }
workmux() { devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash -lc 'workmux "\$@"' _ "\$@"; }
wm() { workmux "\$@"; }
wmz() { devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- env WORKMUX_BACKEND=zellij bash -lc 'workmux "\$@"' _ "\$@"; }
if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -z "\$ZELLIJ" ]] && [[ -z "\$ZELLIJ_AUTO_STARTED" ]] && [[ -z "\$TMUX" ]] && [[ "\$TERM" != "dumb" ]] && command -v devbox >/dev/null 2>&1 && [[ -d "\$COCKPIT_HOME" ]] && [[ -d "\$COCKPIT_DEVBOX_CONFIG" ]]; then
  export ZELLIJ_AUTO_STARTED=1
  cd "\$COCKPIT_HOME"
  exec devbox run -c "\$COCKPIT_DEVBOX_CONFIG" -- bash "\$COCKPIT_HOME/scripts/work.sh"
fi
$MARK_END
EOF2
)

install_block() {
  local file="$1"
  touch "$file"
  if grep -qF "$MARK_START" "$file" 2>/dev/null; then
    SHELL_RC="$file" MARK_START="$MARK_START" MARK_END="$MARK_END" BLOCK="$BLOCK" python3 - <<'PY'
import os
from pathlib import Path
p = Path(os.environ['SHELL_RC'])
s = p.read_text()
start = os.environ['MARK_START']
end = os.environ['MARK_END']
block = os.environ['BLOCK']
before, rest = s.split(start, 1)
_, after = rest.split(end, 1)
p.write_text(before.rstrip() + "\n\n" + block + after)
PY
    echo "✅ Autostart actualizado en $file"
  else
    printf '\n%s\n' "$BLOCK" >> "$file"
    echo "✅ Autostart añadido a $file"
  fi
}

install_bash_bridge() {
  local file="$1"
  local start='# >>> vps-cockpit bashrc bridge >>>'
  local end='# <<< vps-cockpit bashrc bridge <<<'
  local bridge
  bridge=$(cat <<'EOF2'
# >>> vps-cockpit bashrc bridge >>>
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
# <<< vps-cockpit bashrc bridge <<<
EOF2
)
  touch "$file"
  if ! grep -qF "$start" "$file" 2>/dev/null && ! grep -q '\. \?"\?$HOME/.bashrc"\?' "$file" 2>/dev/null; then
    printf '\n%s\n' "$bridge" >> "$file"
    echo "✅ Bridge bashrc añadido a $file"
  fi
}

# Bash is the baseline shell on fresh VPSes: put the real block in .bashrc.
install_block "$HOME/.bashrc"

# SSH often starts bash as a login shell, which reads .profile/.bash_profile first.
# Ensure those files source .bashrc so autostart works after plain `ssh host`.
install_bash_bridge "$HOME/.profile"
[[ -f "$HOME/.bash_profile" ]] && install_bash_bridge "$HOME/.bash_profile"

# If the user later switches login shell to zsh, keep zsh covered too.
[[ -f "$HOME/.zshrc" ]] && install_block "$HOME/.zshrc"
