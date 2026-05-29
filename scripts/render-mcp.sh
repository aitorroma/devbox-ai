#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/scripts/load-env.sh"
mkdir -p "$HOME/.pi/agent"
ROOT="$ROOT" python3 - <<'PY'
import os, string
from pathlib import Path
root = Path(os.environ['ROOT'])
template = string.Template((root/'config/pi/mcp.template.json').read_text())
values = {
    'COOLIFY_BASE_URL': os.environ.get('COOLIFY_BASE_URL', 'https://coolify.tudominio.com'),
    'COOLIFY_ACCESS_TOKEN': os.environ.get('COOLIFY_ACCESS_TOKEN', 'tu-api-token-aqui'),
    'GITHUB_PERSONAL_ACCESS_TOKEN': os.environ.get('GITHUB_PERSONAL_ACCESS_TOKEN', 'tu-token-de-github'),
}
out = Path.home()/'.pi/agent/mcp.json'
out.write_text(template.safe_substitute(values) + '\n')
print(f'✅ MCP config escrita en {out}')
if any(v.startswith('tu-') or 'tudominio' in v for v in values.values()):
    print('⚠️  Hay placeholders: copia .env.example a .env y rellena tokens para Coolify/GitHub.')
PY
