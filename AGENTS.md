# Agent instructions for Devbox AI Cockpit

This repo is intentionally forkable and profile-driven.

## Required skill

When adapting this project, adding packages, creating profiles, changing shell/Zellij behavior, adding MCP servers, or making the cockpit fit a user/team workflow, load and follow:

| Skill | Purpose | Path |
|---|---|---|
| `devbox-ai-extension` | Extend/fork/adapt this cockpit while preserving portability and profile separation. | [skills/devbox-ai-extension/SKILL.md](skills/devbox-ai-extension/SKILL.md) |

## Non-negotiable conventions

- Keep root `devbox.json` as the lightweight `base` profile.
- Add heavy or opinionated tools to `profiles/<name>/` instead of bloating base.
- Use `COCKPIT_HOME` for the repo root and `COCKPIT_DEVBOX_CONFIG` for the selected Devbox profile.
- Do not commit secrets; use `.env.example`, `.env`, and render scripts.
- Validate shell and JSON before committing.
