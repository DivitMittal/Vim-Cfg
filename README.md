<h1 align='center'>Vim-Cfg</h1>
<div align='center'>
    <p></p>
    <div align='center'>
        <a href='https://github.com/DivitMittal/Vim-Cfg'>
            <img src='https://img.shields.io/github/repo-size/DivitMittal/Vim-Cfg?&style=for-the-badge&logo=github'>
        </a>
        <a href='https://github.com/DivitMittal/Vim-Cfg/blob/main/LICENSE'>
            <img src='https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logo=unlicense'/>
        </a>
    </div>
    <br>
</div>

---

<div align='center'>
    <a href="https://github.com/DivitMittal/Vim-Cfg/actions/workflows/flake-check.yml">
        <img src="https://github.com/DivitMittal/Vim-Cfg/actions/workflows/flake-check.yml/badge.svg" alt="Nix Flake Check"/>
    </a>
    <a href="https://github.com/DivitMittal/Vim-Cfg/actions/workflows/flake-lock-update.yml">
        <img src="https://github.com/DivitMittal/Vim-Cfg/actions/workflows/flake-lock-update.yml/badge.svg" alt="Update Flake Lock"/>
    </a>
</div>

---

## Contents

- [Overview](#overview)
- [Project Structure](#project-structure)

---

## Overview

This repository consists of:

- A pure [lua](https://lua.org) [neovim](https://github.com/neovim/neovim) configuration over [NvChad](https://nvchad.com/) for [infra-nixCfg](https://github.com/DivitMittal/infra-nixCfg), deployed via [nix home-manager module, i.e., nix4nvchad](https://github.com/nix-community/nix4nvchad)

- A vimscript [vim](https://vim.org) configuration for [infra-nixCfg](https://github.com/DivitMittal/infra-nixCfg)

The neovim configuration requires neovim 0.12+, a C compiler, and `tree-sitter-cli` 0.26.1+ on `PATH`; run `:TSInstallAll` to install parsers.

## Project Structure

The repository is organized for reproducible Nix-based deployment with modular Lua configurations.

```
.
├── .claude/                  # Claude AI assistant configuration
│   ├── CLAUDE.md             # Symlink to AGENTS.md
│   └── settings.json
├── .github/                  # GitHub Actions workflows
│   └── workflows/
├── flake/                    # Flake-parts module definitions
│   ├── actions/              # GitHub Actions definitions
│   │   ├── default.nix
│   │   ├── flake-check.nix
│   │   └── flake-lock-update.nix
│   ├── checks.nix            # Pre-commit hooks and validation
│   ├── default.nix
│   ├── devshells.nix         # Development shells with LSPs
│   └── formatters.nix        # Code formatting tools
├── lua/                      # Neovim Lua configuration
│   ├── configs/              # Modular plugin configurations
│   │   ├── cmp_config.lua    # Autocompletion settings
│   │   ├── conform_opts.lua  # Code formatting options
│   │   ├── lazy_config.lua   # Plugin manager configuration
│   │   ├── lint_opts.lua     # Linting configuration
│   │   ├── lsp_config.lua    # LSP server configurations
│   │   ├── mason_pkgs.lua    # Language servers/formatters/linters
│   │   └── treesitter_opts.lua # Syntax highlighting configuration
│   ├── plugins/              # Plugin specifications
│   │   ├── ai.lua            # AI/LLM integrations
│   │   ├── general.lua       # General utilities
│   │   ├── init.lua          # Plugin loader
│   │   ├── misc.lua          # Miscellaneous plugins
│   │   ├── notes.lua         # Note-taking plugins
│   │   ├── nvchad.lua        # NvChad-specific plugins
│   │   └── repl.lua          # REPL integrations
│   ├── autocmds.lua          # Autocommands
│   ├── chadrc.lua            # Main NvChad configuration
│   ├── mappings.lua          # Key bindings
│   └── options.lua           # Vim options and settings
├── vim/                      # Vim configuration
│   └── vimrc                 # Traditional vimscript configuration
├── AGENTS.md                 # AI agent instructions
├── flake.lock
├── flake.nix                 # Main flake entry point
├── init.lua                  # Neovim entry point (bootstraps NvChad)
├── LICENSE
├── README.md
└── TODO.md
```

## Related Repositories

- [DivitMittal/infra-nixCfg](https://github.com/DivitMittal/infra-nixCfg): Main Nix configurations repository
## For AI Agents

Context files (`AGENTS.md`, `CLAUDE.md`) are generated — not committed. Run `apm compile` before exploring the repo to get directory-level guidance.
