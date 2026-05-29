# VPS Cockpit portable con Devbox

Objetivo: clonar este directorio en cualquier VPS y reconstruir el entorno sin depender de estado local oculto.

## Primer arranque

```bash
curl -fsSL https://get.jetify.com/devbox | bash   # si devbox no existe
git clone <este-repo> cockpit
cd cockpit
devbox shell
devbox run setup
devbox run gentle-install      # wizard interactivo
devbox run pi-plugins
devbox run mcp-render          # genera ~/.pi/agent/mcp.json desde plantilla
devbox run zellij-install      # opcional: autostart por SSH
```

## Secretos por VPS

```bash
cp .env.example .env
$EDITOR .env
devbox run mcp-render
```

`.env` no debe commitearse. La plantilla portable está en `config/pi/mcp.template.json`.

## Verificación

```bash
devbox run doctor
pi
/gentle-ai:status
```
