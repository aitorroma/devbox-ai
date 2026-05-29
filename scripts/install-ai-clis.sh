#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.npm-global"
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

echo '🤖 Instalando/actualizando OpenAI Codex CLI...'
npm install -g @openai/codex

echo '🤖 Instalando/actualizando Claude Code CLI...'
npm install -g @anthropic-ai/claude-code

echo '✅ AI CLIs listas: codex, claude'
