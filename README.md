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

## Recuperar SSH si el autostart de Zellij falla

Si el servidor no tiene `zsh`, usa `bash`. La variable `ZELLIJ_AUTO_STARTED=1` salta el autostart para poder reparar:

```bash
ssh -t root@TU_SERVIDOR 'ZELLIJ_AUTO_STARTED=1 bash -l'
```

Dentro del servidor:

```bash
cd /root/cookpit   # o la ruta donde clonaste este repo
git pull
devbox run -c "$PWD" -- zellij-install
```

Prueba manual sin depender del directorio actual:

```bash
devbox run -c /root/cookpit -- zellij --session dev --new-session-with-layout /root/cookpit/config/zellij/layouts/dev.kdl
```
