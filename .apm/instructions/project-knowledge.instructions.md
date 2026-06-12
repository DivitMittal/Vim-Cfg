## Overview

This repository contains a dual Vim/Neovim configuration system built for NixOS deployment:

- **Neovim Configuration**: A pure Lua configuration built on top of NvChad framework, deployed via the nix4nvchad home-manager module
- **Vim Configuration**: A traditional vimscript configuration for vanilla Vim

The project uses Nix flakes for reproducible development environments and automated CI/CD workflows.

## Architecture

### Configuration Structure

**Neovim (Primary Configuration)**:
- `init.lua`: Entry point that bootstraps NvChad and loads all configuration modules
- `lua/chadrc.lua`: Main NvChad configuration with theme, UI, and integration settings
- `lua/configs/`: Modular configuration files for different components:
  - `lsp_config.lua`: LSP server configurations with Lspsaga integration
  - `mason_pkgs.lua`: List of language servers, formatters, and linters to install
  - `cmp_config.lua`: Autocompletion settings
  - `conform_opts.lua`: Code formatting options
  - `lazy_config.lua`: Plugin manager configuration
  - `lint_opts.lua`: Linting configuration
  - `treesitter_opts.lua`: Syntax highlighting configuration
- `lua/options.lua`: Vim options and settings
- `lua/mappings.lua`: Key bindings and shortcuts
- `lua/autocmds.lua`: Autocommands for automated behaviors
- `lua/plugins/init.lua`: Plugin specifications

**Vim (Legacy Configuration)**:
- `vim/vimrc`: Traditional vimscript configuration for vanilla Vim

### Nix Infrastructure

**Flake Structure**:
- `flake.nix`: Main flake definition with inputs and outputs
- `flake/`: Modular flake components:
  - `checks.nix`: Pre-commit hooks and validation rules
  - `formatters.nix`: Code formatting tools (Lua with stylua, Nix with alejandra)
  - `devshells.nix`: Development environment with LSPs and tools
  - `actions/`: GitHub Actions workflow definitions

## Development Commands

### Nix Environment
```bash
# Enter development shell with all tools
nix develop

# Format all code
nix fmt
```

### Testing and Validation
```bash
# Validate flake structure and dependencies
nix flake check --impure --all-systems --no-build
```

## Language Server Configuration

The Neovim configuration includes comprehensive LSP support for:

**Core Languages**: Lua (lua-language-server), Nix (nixd), C/C++ (clangd), Python (python-lsp-server), Shell (bash-language-server)

**Web Development**: HTML/CSS, Markdown, JavaScript/TypeScript (deno, ts_ls), Vue, Emmet

**Data Formats**: YAML (yaml-language-server), TOML (taplo), XML

## Deployment

This configuration is designed for deployment via:
- **nix4nvchad**: Home-manager module for NixOS systems
- **OS-nixCfg**: Parent NixOS configuration repository
