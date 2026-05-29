# Herramientas incluidas

Este cockpit instala herramientas en dos capas:

- **Devbox/Nix**: herramientas reproducibles del sistema, disponibles dentro de `devbox shell`, `devbox run ...` y el workspace `work`.
- **npm global en `$HOME/.npm-global`**: CLIs de agentes IA (`pi`, `codex`, `claude`) para uso diario rápido.

## Cockpit y shell

| Tool | Para qué sirve |
|---|---|
| `devbox` | Entorno reproducible basado en Nix. Lee `devbox.json` y provisiona las herramientas. |
| `zellij` | Multiplexor de terminal persistente. Mantiene sesiones vivas al cerrar SSH. |
| `zsh` | Shell interactiva configurada tipo workstation. |
| `fzf` | Búsqueda fuzzy interactiva para archivos, historial y selección rápida. |
| `zoxide` | `cd` inteligente basado en frecuencia/recencia de directorios. |
| `atuin` | Historial de shell avanzado y buscable. |
| `carapace` | Motor de completions multi-shell. |
| `zsh-autocomplete` | Autocompletado proactivo para Zsh. |
| `zsh-autosuggestions` | Sugerencias de comandos basadas en historial. |
| `zsh-syntax-highlighting` | Colorea comandos válidos/erróneos mientras escribes. |
| `eza` | Reemplazo moderno de `ls`. |
| `bat` | Reemplazo de `cat` con syntax highlighting. |

## Agentes IA

| Tool | Para qué sirve |
|---|---|
| `pi` | Agente de coding en terminal. |
| `gentle-ai` | Harness/workflows para configurar Pi, skills y memoria. |
| `engram` | Memoria persistente del agente vía MCP. Se configura mediante plugins/scripts. |
| `codex` | OpenAI Codex CLI. |
| `claude` | Claude Code CLI. |

## Git, GitHub y dotfiles

| Tool | Para qué sirve |
|---|---|
| `git` | Control de versiones. |
| `gh` | GitHub CLI para repos, issues, PRs y auth. |
| `lazygit` | UI TUI para Git. |
| `delta` | Visor bonito de diffs Git. |
| `chezmoi` | Gestión portable de dotfiles. |
| `pre-commit` | Framework para hooks de calidad antes de commit. |

## Datos, texto y automatización

| Tool | Para qué sirve |
|---|---|
| `jq` | Procesar JSON desde terminal. |
| `yq` | Procesar YAML/XML/TOML; útil para config y Kubernetes. |
| `just` | Runner de comandos tipo `Makefile` más ergonómico. |
| `make` (`gnumake`) | Automatización clásica de builds/tareas. |
| `tree` | Ver estructura de carpetas en árbol. |
| `rsync` | Sincronización/copias incrementales. |
| `wget` | Descargar archivos por HTTP/FTP. |
| `direnv` | Cargar variables de entorno por directorio. |

## Lenguajes y toolchains

| Tool | Para qué sirve |
|---|---|
| `node` / `npm` | Runtime y package manager JavaScript/TypeScript. |
| `python3.12` | Python 3.12. |
| `pip` | Instalador de paquetes Python. |
| `uv` | Gestor rápido de proyectos/paquetes Python. |
| `go` | Toolchain Go. |
| `rustup` | Gestor de toolchains Rust. |
| `gcc` | Compilador C/C++. |

## Contenedores, Kubernetes e infraestructura

| Tool | Para qué sirve |
|---|---|
| `docker` (`docker-client`) | Cliente Docker para hablar con un daemon Docker. |
| `docker-compose` | Orquestación local con Compose. |
| `helm` (`kubernetes-helm`) | Package manager de Kubernetes. |
| `kubectl` | CLI oficial de Kubernetes. |
| `k9s` | TUI para navegar clusters Kubernetes. |
| `terraform` | Infraestructura como código de HashiCorp. |
| `tofu` (`opentofu`) | Fork open-source de Terraform. |
| `ansible` | Automatización/configuración remota por SSH. |

## Seguridad, secretos y criptografía

| Tool | Para qué sirve |
|---|---|
| `openssl` | Toolkit TLS/crypto/certificados. |
| `age` | Cifrado moderno de archivos. |
| `sops` | Gestión de secretos cifrados en YAML/JSON/env files. |

## Observabilidad y sistema

| Tool | Para qué sirve |
|---|---|
| `btop` | Monitor de recursos TUI moderno. |
| `htop` | Monitor de procesos interactivo. |
| `duf` | Uso de disco por filesystem, más legible que `df`. |
| `ncdu` | Analizador interactivo de uso de disco por directorio. |

## Red y diagnóstico

| Tool | Para qué sirve |
|---|---|
| `http` (`httpie`) | Cliente HTTP legible para APIs. |
| `xh` | Cliente HTTP rápido estilo HTTPie. |
| `nmap` | Escaneo de red/puertos. |
| `dig` (`dnsutils`) | Consultas DNS. |
| `whois` | Consultas WHOIS de dominios/IPs. |
| `tcpdump` | Captura de paquetes. |
| `mtr` | Diagnóstico de rutas/red combinando ping + traceroute. |

## Calidad de shell/código

| Tool | Para qué sirve |
|---|---|
| `shellcheck` | Linter para scripts shell. |
| `shfmt` | Formateador de shell scripts. |

## Comandos de verificación

```bash
devbox run doctor
```

O checks puntuales:

```bash
devbox run -c /root/cookpit -- ansible --version
devbox run -c /root/cookpit -- lazygit --version
devbox run -c /root/cookpit -- chezmoi --version
```
