<div align="center">

  <a href="https://t.me/aitorroma">
    <img src="https://tva1.sinaimg.cn/large/008i3skNgy1gq8sv4q7cqj303k03kweo.jpg" alt="Aitor Roma" />
  </a>

  <br>

  [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J64AN17)

  <br>

  <a href="https://t.me/aitorroma">
    <img src="https://img.shields.io/badge/Telegram-informational?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram Badge"/>
  </a>
</div>

# Devbox AI Cockpit

Cockpit portable para trabajar por SSH en un VPS con perfiles seleccionables para no instalar más de lo necesario.

- **Devbox/Nix** para reproducibilidad
- **Zellij** como workspace persistente
- **Zsh** con prompt compacto custom
- **Perfiles** `base`, `ai`, `devops` y `full`
- **Pi + gentle-ai + Engram**, **Codex CLI**, **Claude Code CLI**, **OpenCode CLI**, **Antigravity CLI (agy)**, **Workmux** y **RTK** solo en perfiles IA
- Plantillas MCP para **Engram**, **Coolify**, **Context7** y **GitHub**


## Demo

<a href="https://asciinema.org/a/1161930" target="_blank" rel="noopener noreferrer">
  <img src="https://asciinema.org/a/1161930.svg" alt="Demo del Devbox AI Cockpit en Asciinema" width="100%" />
</a>

> Haz clic en la imagen para reproducir el asciicast. GitHub muestra la previsualización SVG en el README, pero no permite ejecutar el reproductor JavaScript embebido.


## Extender y adaptar tu fork

Este repo está pensado para que cualquiera lo pueda forquear y adaptar sin romper la portabilidad. Hay una guía y una skill para agentes IA:

- [docs/EXTENDING.md](docs/EXTENDING.md) — guía para crear perfiles, añadir MCPs, paquetes, layouts y scripts.
- [skills/devbox-ai-extension/SKILL.md](skills/devbox-ai-extension/SKILL.md) — skill para que un agente pueda modificar el cockpit siguiendo las convenciones del proyecto.
- [AGENTS.md](AGENTS.md) — instrucciones para agentes en forks.

Ejemplo para crear un perfil propio:

```bash
mkdir -p profiles/company
cp skills/devbox-ai-extension/assets/devbox-profile-template.json profiles/company/devbox.json
cd profiles/company
devbox update
```

## Perfiles disponibles

| Perfil | Qué instala | Cuándo usarlo |
|---|---|---|
| `base` | Shell/cockpit mínimo: Zellij, Zsh, Neovim, búsqueda, prompt y Python para scripts. | VPS ligero o solo terminal portable. |
| `ai` | `base` + Node.js + Pi/gentle-ai + Codex + Claude + OpenCode + Antigravity CLI + Workmux + RTK. | Cockpit IA sin toolpack DevOps pesado. **Recomendado**. |
| `devops` | `base` + toolpack DevOps/infra, sin agentes IA. | VPS para operar infra sin CLIs IA. |
| `full` | `ai` + `devops`. | Quieres absolutamente todo y tienes disco/RAM de sobra. |

La idea es que normalmente uses `ai` en el VPS de desarrollo y solo instales `devops` o `full` cuando realmente necesites Docker/K8s/Terraform/Ansible/etc.

## Instalación rápida en VPS nuevo

```bash
apt update && apt install -y curl git bash
curl -fsSL https://get.jetify.com/devbox | bash
git clone https://github.com/aitorroma/devbox-ai.git /root/cookpit
cd /root/cookpit
```

Elige perfil con el instalador rápido:

```bash
# IA: cockpit + agentes, sin toolpack DevOps pesado
./scripts/bootstrap.sh --profile ia

# Solo DevOps: cockpit + herramientas infra, sin agentes IA
./scripts/bootstrap.sh --profile devops

# Todo
./scripts/bootstrap.sh --profile full
```

Atajos equivalentes: `./scripts/bootstrap.sh ia`, `devbox run bootstrap`, o `devbox run -c /root/cookpit/profiles/ai -- bootstrap`. Desde la raíz, `devbox run bootstrap` instala el perfil `ai` por defecto.

Al terminar, recarga shell o reconecta por SSH:

```bash
source ~/.bashrc
work-reset
```

El wizard interactivo de gentle-ai es opcional y solo aplica a `ai`/`full`:

```bash
gentle-install
# o
devbox run -c /root/cookpit/profiles/ai -- gentle-install
```

## Cambiar de perfil

Para el día a día no hace falta memorizar rutas de Devbox. Lanza el cockpit con el perfil deseado:

```bash
work --profile ia
work --profile devops
work --profile full
```

También tienes aliases cortos:

```bash
work-ia
work-devops
work-full
```

Para actualizar repo + herramientas + aliases de un perfil concreto:

```bash
work-update --profile ia
work-update --profile devops
work-update --profile full
```

Aliases equivalentes: `update-ia`, `update-devops`, `update-full`.

Si el cambio incluye layout de Zellij, ejecuta fuera de Zellij:

```bash
work --profile ia --reset
```

Ver perfil activo:

```bash
profile-info
# o
devbox run -c /root/cookpit/profiles/ai -- profile-info
```

## Toolpack por perfil

### `base`

```text
git curl unzip neovim ripgrep fd zellij zsh fzf zoxide atuin
bat eza carapace zsh-autocomplete zsh-autosuggestions
zsh-syntax-highlighting python312
```

### `ai`

`base` +:

```text
nodejs@22
Pi gentle-ai Codex Claude OpenCode Antigravity CLI (agy) Workmux RTK instalados en $HOME
```

### `devops`

`base` +:

```text
jq yq gh lazygit delta chezmoi
duf btop htop ncdu tree wget rsync rclone ngrok tmate asciinema openssl
age sops direnv just make gcc
python312Packages.pip uv go rustup
docker-client docker-compose kubernetes-helm kubectl k9s
terraform opentofu ansible awscli2 google-cloud-sdk
httpie xh nmap dnsutils whois tcpdump mtr
pre-commit shellcheck shfmt
```

Ver [TOOLS.md](./TOOLS.md) para saber qué hace cada herramienta.

## Layout de Zellij

El workspace intencionalmente tiene **dos tabs**:

1. **SYSTEM** — una shell grande, limpia, iniciando en `~`.
2. **IA** — el cockpit de trabajo con tres panes, iniciando en el repo.

Si cambias el layout o ves tabs antiguas, recrea la sesión desde fuera de Zellij:

```bash
devbox run -c /root/cookpit/profiles/ai -- work-reset
```

## Comandos diarios

```bash
work                         # abre/adjunta Zellij dev con el perfil activo
work --profile ia            # cambia/arranca cockpit IA
work --profile devops        # cambia/arranca cockpit DevOps
work --profile full          # cambia/arranca cockpit completo
work-reset                   # recrea la sesión dev y reaplica layout
work-update                  # git pull + reinstala shell/autostart + actualiza perfil activo
work-update --profile full   # actualiza usando otro perfil
doctor                       # verifica herramientas/versiones del perfil activo
profile-info                 # muestra perfil y rutas activas
```

En perfiles `ai`/`full` también:

```bash
agent         # lanza Pi
codex         # lanza Codex CLI
claude        # lanza Claude Code CLI
opencode      # lanza OpenCode CLI
agy           # lanza Antigravity CLI
workmux / wm  # gestiona worktrees/agentes con multiplexer
wmz           # fuerza backend Zellij para Workmux
rtk gain      # muestra ahorro acumulado de tokens
```

Si los aliases aún no están cargados, usa el perfil explícito:

```bash
devbox run -c /root/cookpit/profiles/ai -- work
devbox run -c /root/cookpit/profiles/ai -- work-update
devbox run -c /root/cookpit/profiles/devops -- doctor
```

## Secretos por VPS

Solo para perfiles IA:

```bash
cd /root/cookpit
cp .env.example .env
nano .env
devbox run -c /root/cookpit/profiles/ai -- mcp-render
```

`.env` no se commitea. La plantilla portable está en `config/pi/mcp.template.json`.

## Actualizar cockpit

```bash
work-update                  # perfil activo
work-update --profile ia     # fuerza perfil IA
work-update --profile devops # fuerza perfil DevOps
work-update --profile full   # fuerza perfil completo
```

Si estás dentro de Zellij y te avisa que no puede matar la sesión actual, sal/reconecta o ejecuta desde fuera con el perfil activo:

```bash
devbox run -c /root/cookpit/profiles/ai -- work-reset
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
devbox run -c /root/cookpit/profiles/ai -- zellij-install
devbox run -c /root/cookpit/profiles/ai -- work-reset
```

## Zsh portable

La configuración zsh incluye un prompt compacto custom como el de tu terminal actual, autosuggestions, syntax highlighting, autocomplete, fzf, zoxide, atuin, eza, bat y carapace. No copia secretos ni rutas locales.

Reinstalar solo zsh para un perfil:

```bash
devbox run -c /root/cookpit/profiles/ai -- zsh-install
```

## RTK para ahorrar tokens

RTK se instala solo en perfiles `ai`/`full`, desde `rtk-ai/rtk`, y queda en `$HOME/.local/bin`. El setup ejecuta también los hooks globales para Claude/Copilot y Codex:

```bash
rtk init -g
rtk init -g --codex
```

Verificación:

```bash
rtk --version
rtk gain
```

Reinstalar/actualizar solo RTK:

```bash
devbox run -c /root/cookpit/profiles/ai -- rtk-install
```

## Antigravity CLI

Antigravity CLI (`agy`) entiende el codebase, propone ediciones con permiso y ejecuta comandos desde la terminal. El instalador oficial para macOS/Linux es:

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

En este cockpit se instala de forma portable en `$HOME/.local/bin` con:

```bash
devbox run -c /root/cookpit/profiles/ai -- antigravity-install
```

En SSH, `agy` imprime una URL de autorización para completar login localmente. Para cerrar sesión dentro del CLI usa `/logout`.

## AI CLIs

Los perfiles `ai`/`full` instalan Pi, gentle-ai, Codex, Claude, OpenCode, Antigravity CLI, Workmux y RTK. Antigravity se instala desde el instalador oficial de Google y deja el binario `agy` en `$HOME/.local/bin`. OpenCode se instala vía npm como `opencode-ai`; Workmux se instala en `$HOME/.local/bin`.

```bash
codex --version
claude --version
opencode --version
workmux --version
agy --version
pi --version
gentle-ai --version
```

Para reinstalarlos/actualizarlos manualmente:

```bash
devbox run -c /root/cookpit/profiles/ai -- ai-clis
devbox run -c /root/cookpit/profiles/ai -- workmux-install
devbox run -c /root/cookpit/profiles/ai -- antigravity-install
```

## Workmux + Zellij

[Workmux](https://workmux.raine.dev/) crea worktrees y abre agentes en tu multiplexer. En este cockpit queda disponible como `workmux` y como alias corto `wm`.

```bash
wm init                 # opcional: crea .workmux.yaml en un proyecto
wm add nueva-feature   # crea worktree y ventana/tab de trabajo
wmz add fix-login      # fuerza WORKMUX_BACKEND=zellij
```

Según la guía oficial, el backend Zellij de Workmux es experimental y depende de capacidades recientes/no publicadas de Zellij; si falla, actualiza Zellij o usa el backend tmux/otro terminal soportado. Dentro de Zellij, Workmux puede autodetectar el backend por `$ZELLIJ`; `wmz` lo fuerza con `WORKMUX_BACKEND=zellij`.

## Evitar tabs duplicadas en Zellij

No ejecutes `work` o `work-reset` desde dentro de Zellij para recrear el layout: Zellij puede interpretarlo como añadir una tab nueva.

Para resetear desde una shell normal fuera de Zellij:

```bash
ZELLIJ_AUTO_STARTED=1 bash -lc 'cd /root/cookpit && devbox run -c /root/cookpit/profiles/ai -- work-reset'
```

Para borrar una sesión vieja/EXITED manualmente:

```bash
devbox run -c /root/cookpit/profiles/ai -- zellij delete-session --force dev
devbox run -c /root/cookpit/profiles/ai -- work
```
