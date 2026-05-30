---
name: devbox-ai-extension
description: >
  Guides agents and maintainers when extending, forking, or adapting Devbox AI Cockpit with new profiles, packages, shell config, MCPs, scripts, or docs.
  Trigger: Use when asked to customize this cockpit, add a tool, create a profile, change Zellij/Zsh behavior, add MCP servers, or make a fork fit a user's workflow.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

Use this skill when the task involves:

- Adding/removing packages or creating a new selectable Devbox profile.
- Adapting the cockpit for a fork, team, company, VPS provider, or personal workflow.
- Adding MCP servers, AI agents, shell integrations, Zellij layouts, bootstrap steps, or install scripts.
- Keeping the project portable and easy to update after local customizations.

## Critical Patterns

1. **Keep root `devbox.json` lightweight.** The root profile is `base`; heavy toolchains belong in `profiles/<name>/`.
2. **Use selectable profiles instead of one huge install.** Existing profiles are `base`, `ai`, `devops`, and `full`.
3. **Never hardcode the repo path.** Scripts must use `COCKPIT_HOME` for the repo root and `COCKPIT_DEVBOX_CONFIG` for the active profile directory.
4. **Aliases must target the active profile.** Use `devbox run -c "$COCKPIT_DEVBOX_CONFIG" -- ...`, not the repo root unless intentionally using `base`.
5. **Keep secrets out of git.** Put placeholders in `.env.example`, templates in `config/**`, and render user secrets locally.
6. **Document every new extension point.** Update `README.md`, `TOOLS.md`, and `docs/EXTENDING.md` when adding profiles/tools/scripts.
7. **Validate all profile JSON and shell scripts before commit.** Use the commands below.

## Extension Decision Tree

| Goal | Recommended change |
|---|---|
| Add a lightweight shell tool used by everyone | Add to root `devbox.json` (`base`) and all derived profiles if needed. |
| Add a heavy DevOps/infra tool | Add to `profiles/devops/devbox.json` and `profiles/full/devbox.json`. |
| Add an AI/agent tool | Add to `profiles/ai/devbox.json` and `profiles/full/devbox.json`; update `scripts/setup.sh` and/or a dedicated installer if installed outside Nix. Example: Antigravity CLI uses `scripts/install-antigravity.sh`. |
| Add optional team/company stack | Create `profiles/<team>/devbox.json` instead of bloating existing profiles. |
| Add secrets or tokens | Add placeholder to `.env.example` and render into ignored local config via script. |
| Change panes/tabs | Edit `config/zellij/layouts/dev.kdl.template`; reset with `work-reset` from outside Zellij. |
| Change prompt/shell behavior | Edit `config/zsh/zshrc`; reinstall with `zsh-install`. |
| Add MCP server | Edit `config/pi/mcp.template.json`, `.env.example`, and `scripts/render-mcp.sh`. |

## Profile Template

Use [assets/devbox-profile-template.json](assets/devbox-profile-template.json) as the starting point for new profile directories.

Minimum profile rules:

```json
{
  "shell": {
    "init_hook": [
      "export COCKPIT_PROFILE=myprofile",
      "export COCKPIT_HOME=\"$(cd ../.. && pwd)\"",
      "export COCKPIT_DEVBOX_CONFIG=\"$(pwd)\""
    ]
  }
}
```

Scripts from profile directories should call shared scripts with `../../scripts/...`.

## Commands

```bash
# Check current profile wiring
devbox run -c profiles/ai -- profile-info
devbox run -c profiles/devops -- profile-info

# Validate files
bash -n scripts/*.sh
zsh -n config/zsh/zshrc
for f in devbox.json profiles/*/devbox.json; do python3 -m json.tool "$f" >/dev/null; done

# Update a profile lock after editing packages
cd profiles/myprofile && devbox update

# Apply profile on a VPS
devbox run -c /root/cookpit/profiles/myprofile -- bootstrap
```

## Fork Adaptation Checklist

- [ ] Decide whether the change belongs in `base`, `ai`, `devops`, `full`, or a new profile.
- [ ] Keep generated/local state ignored (`.env`, `.devbox/`, `.venv/`, `.pi/`, `.zellij/`).
- [ ] Add/adjust install scripts only when the tool cannot be managed by Devbox/Nix.
- [ ] Use placeholders and render scripts for any secret-bearing config.
- [ ] Update docs and `TOOLS.md` for new tools.
- [ ] Run validation commands.
- [ ] Commit with a message naming the extension point changed.

## Resources

- **Extension guide**: See [references/extending.md](references/extending.md).
- **Profile template**: See [assets/devbox-profile-template.json](assets/devbox-profile-template.json).
