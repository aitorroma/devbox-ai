# Extending Devbox AI Cockpit

This project is designed to be forked. The safest way to customize it is to add extension points instead of editing everything in place.

## Architecture

| Layer | Where | Purpose |
|---|---|---|
| Profiles | `devbox.json`, `profiles/*/devbox.json` | Select which package set to install. |
| Shared scripts | `scripts/*.sh` | Bootstrap, shell install, profile info, MCP rendering, updates. |
| Shell UX | `config/zsh/zshrc` | Prompt, aliases, completions and shortcuts. |
| Workspace | `config/zellij/layouts/dev.kdl.template` | Zellij tabs and panes. |
| MCP config | `config/pi/mcp.template.json` + `.env.example` | Portable agent integrations without committing secrets. |
| Agent skill | `skills/devbox-ai-extension/SKILL.md` | Instructions for AI agents adapting the repo. |

## Profiles

The root `devbox.json` is the small `base` profile. Heavier stacks live under `profiles/`:

- `profiles/ai` — Node + Pi/gentle-ai/Codex/Claude/RTK.
- `profiles/devops` — infra and operations tools.
- `profiles/full` — everything.

Create new profiles when customization would make the default profiles too opinionated.

```bash
mkdir -p profiles/company
cp skills/devbox-ai-extension/assets/devbox-profile-template.json profiles/company/devbox.json
cd profiles/company
devbox update
```

Then install it on a VPS:

```bash
devbox run -c /root/cookpit/profiles/company -- bootstrap
```

## Environment contracts

Shared scripts rely on these variables:

| Variable | Meaning |
|---|---|
| `COCKPIT_HOME` | Repo root, e.g. `/root/cookpit`. |
| `COCKPIT_DEVBOX_CONFIG` | Active profile directory, e.g. `/root/cookpit/profiles/ai`. |
| `COCKPIT_PROFILE` | Human-friendly profile name. |
| `COCKPIT_ENABLE_AI` | `1` when agent tooling should be installed/checked. |
| `COCKPIT_ENABLE_DEVOPS` | `1` when DevOps tooling should be installed/checked. |

Do not replace these with hardcoded paths in forks.

## Adding packages

| Package type | Add it to |
|---|---|
| Small shell/cockpit dependency | `devbox.json` and relevant derived profiles. |
| AI/agent dependency managed by Nix | `profiles/ai/devbox.json` and `profiles/full/devbox.json`. |
| AI/agent dependency installed by npm/curl | `scripts/setup.sh` or a dedicated script, guarded by `COCKPIT_ENABLE_AI=1`. |
| DevOps/infra dependency | `profiles/devops/devbox.json` and `profiles/full/devbox.json`. |
| Team-specific tool | New `profiles/<team>/devbox.json`. |

After editing packages, update the corresponding lock:

```bash
cd profiles/ai && devbox update
cd profiles/devops && devbox update
cd profiles/full && devbox update
```

## Adding MCP servers

1. Add environment placeholders to `.env.example`.
2. Add the MCP server block to `config/pi/mcp.template.json`.
3. Update `scripts/render-mcp.sh` with substitutions.
4. Document the integration in `README.md` or `TOOLS.md`.
5. Never commit real tokens.

## Changing the workspace

- Zellij tabs/panes: edit `config/zellij/layouts/dev.kdl.template`.
- Shell prompt/aliases: edit `config/zsh/zshrc`.
- Autostart/aliases in login shells: edit `scripts/install-zellij-autostart.sh`.

Apply changes:

```bash
devbox run -c /root/cookpit/profiles/ai -- zsh-install
devbox run -c /root/cookpit/profiles/ai -- zellij-install
devbox run -c /root/cookpit/profiles/ai -- work-reset
```

Run `work-reset` from outside Zellij to avoid duplicate tabs.

## Validation

```bash
bash -n scripts/*.sh
zsh -n config/zsh/zshrc
for f in devbox.json profiles/*/devbox.json; do python3 -m json.tool "$f" >/dev/null; done

devbox run -c profiles/ai -- profile-info
devbox run -c profiles/devops -- profile-info
```

## Recommended fork workflow

1. Fork the repo.
2. Create a profile under `profiles/<your-name>`.
3. Keep upstream profiles intact when possible.
4. Put secrets in `.env`, not git.
5. Update `docs/EXTENDING.md` if you add new extension conventions.
6. Ask your AI agent to use `skills/devbox-ai-extension` before modifying the cockpit.
