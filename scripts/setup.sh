#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/.npm-global" "$HOME/.local/bin"
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

if [[ "${COCKPIT_ENABLE_AI:-0}" != "1" ]]; then
  echo "ℹ️  Perfil ${COCKPIT_PROFILE:-base}: sin agentes IA. Salto Pi/gentle-ai/Codex/Claude/OpenCode/RTK/Antigravity/Workmux."
  exit 0
fi

echo '📦 Instalando/actualizando Pi...'
npm install -g --ignore-scripts @earendil-works/pi-coding-agent

echo '📦 Instalando/actualizando gentle-ai latest...'
GENTLE_TAG="$(curl -fsSL https://api.github.com/repos/Gentleman-Programming/gentle-ai/releases/latest | node -e "let d=''; process.stdin.on('data', c => d += c); process.stdin.on('end', () => console.log(JSON.parse(d).tag_name));")"
GENTLE_VERSION="${GENTLE_TAG#v}"
ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
GENTLE_ASSET="gentle-ai_${GENTLE_VERSION}_${OS}_${ARCH}.tar.gz"
GENTLE_URL="https://github.com/Gentleman-Programming/gentle-ai/releases/download/${GENTLE_TAG}/${GENTLE_ASSET}"
echo "⬇️  ${GENTLE_ASSET}"
curl -fsSL "$GENTLE_URL" | tar xz -C "$HOME/.local/bin"
chmod +x "$HOME/.local/bin/gentle-ai"

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install-ai-clis.sh"

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install-rtk.sh"

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install-antigravity.sh"

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install-workmux.sh"

echo '✅ Binarios listos.'
echo 'Siguiente: devbox run gentle-install && devbox run pi-plugins && devbox run mcp-render'
