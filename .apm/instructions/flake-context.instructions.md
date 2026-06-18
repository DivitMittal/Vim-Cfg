---
description: Nix flake infrastructure for the Vim-Cfg project
applyTo: "flake/**"
---

## Flake Infrastructure

`flake.nix` auto-imports every `.nix` file under `flake/` via `customLib.scanPaths`. Adding a file to this directory is enough — no explicit import needed.

### Files in `flake/`

- `formatters.nix`: treefmt config — alejandra for Nix files, stylua for Lua files.
- `checks.nix`: pre-commit hooks (whitespace trimming, large-file guard, merge-conflict detection, and format validation).
- `devshells.nix`: development shell providing nixd, alejandra, stylua, and apm-cli.
- `actions/`: GitHub Actions workflow definitions via actions-nix. **Do NOT edit `.github/workflows/` directly** — regenerate from here instead.

### Rules

- Run `nix fmt` before committing any change in this directory.
- Do not add raw workflow YAML to `.github/workflows/`; define workflows in `actions/` and let actions-nix render them.
- Keep formatter and linter versions pinned through flake inputs, not shell ad-hoc installs.
