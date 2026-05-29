# Devbox AI Cockpit

Cockpit portable para trabajar por SSH en un VPS con:

- **Devbox/Nix** para reproducibilidad
- **Zellij** como workspace persistente
- **Zsh** configurado tipo workstation
- **Pi + gentle-ai + Engram** como agente con memoria
- **Codex CLI** y **Claude Code CLI** instalados por npm
- Plantillas MCP para **Engram**, **Coolify**, **Context7** y **GitHub**

## Instalación rápida en VPS nuevo

```bash
apt update && apt install -y curl git bash
curl -fsSL https://get.jetify.com/devbox | bash
git clone https://github.com/aitorroma/devbox-ai.git /root/cookpit
cd /root/cookpit
devbox run bootstrap
```

Al terminar, recarga shell o reconecta por SSH:

```bash
source ~/.bashrc
work-reset
```

El wizard interactivo de gentle-ai es opcional y se ejecuta aparte:

```bash
gentle-install
# o
devbox run -c /root/cookpit -- gentle-install
```

## Instalación manual paso a paso

```bash
cd /root/cookpit
devbox run setup        # instala Pi, gentle-ai, Codex y Claude
devbox run zsh-install
devbox run pi-plugins
devbox run mcp-render
devbox run zellij-install
```

## Comandos diarios

```bash
work          # abre/adjunta Zellij dev
work-reset    # recrea la sesión dev y reaplica layout
work-update   # git pull + reinstala shell/autostart + actualiza cockpit
doctor        # verifica herramientas/versiones
agent         # lanza Pi
codex         # lanza Codex CLI
claude        # lanza Claude Code CLI
```

Si los aliases aún no están cargados:

```bash
devbox run -c /root/cookpit -- work
devbox run -c /root/cookpit -- work-reset
devbox run -c /root/cookpit -- work-update
devbox run -c /root/cookpit -- doctor
devbox run -c /root/cookpit -- agent
```

## Secretos por VPS

```bash
cd /root/cookpit
cp .env.example .env
nano .env
devbox run mcp-render
```

`.env` no se commitea. La plantilla portable está en `config/pi/mcp.template.json`.

## Actualizar cockpit

```bash
work-update
```

Si estás dentro de Zellij y te avisa que no puede matar la sesión actual, sal/reconecta o ejecuta desde fuera:

```bash
devbox run -c /root/cookpit -- work-reset
```

## Recuperar SSH si el autostart falla

Salta el autostart con `ZELLIJ_AUTO_STARTED=1`:

```bash
ssh -t root@TU_SERVIDOR 'ZELLIJ_AUTO_STARTED=1 bash -l'
```

Dentro:

```bash
cd /root/cookpit
git pull
devbox run -c "$PWD" -- zellij-install
devbox run -c "$PWD" -- work-reset
```

## Zsh portable

La configuración zsh incluye Powerlevel10k, autosuggestions, syntax highlighting, autocomplete, fzf, zoxide, atuin, eza, bat y carapace. No copia secretos ni rutas locales.

Reinstalar solo zsh:

```bash
devbox run -c /root/cookpit -- zsh-install
```

## Verificación

```bash
doctor
pi
/gentle-ai:status
```

## AI CLIs

El bootstrap instala también:

```bash
codex --version
claude --version
```

Para reinstalarlos/actualizarlos manualmente:

```bash
devbox run -c /root/cookpit -- ai-clis
```

## Evitar tabs duplicadas en Zellij

No ejecutes `work` o `work-reset` desde dentro de Zellij para recrear el layout: Zellij puede interpretarlo como añadir una tab nueva.

Para resetear desde una shell normal fuera de Zellij:

```bash
ZELLIJ_AUTO_STARTED=1 bash -lc 'cd /root/cookpit && devbox run -c /root/cookpit -- work-reset'
```

Para borrar una sesión vieja/EXITED manualmente:

```bash
devbox run -c /root/cookpit -- zellij delete-session --force dev
devbox run -c /root/cookpit -- work
```
