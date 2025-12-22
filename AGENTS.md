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

**Development Environment**:
The project provides a Nix development shell with:
- Language servers: nixd (Nix), lua-language-server
- Formatters: stylua (Lua), alejandra (Nix)
- Pre-commit hooks for code quality

## Development Commands

### Nix Environment
```bash
# Enter development shell with all tools
nix develop

# Run formatting checks
nix fmt

# Run all flake checks (linting, formatting, validation)
nix flake check --impure --all-systems

# Format all code
nix fmt
```

### Code Formatting
```bash
# Format Lua files
stylua .

# Format Nix files
alejandra .
```

### Pre-commit Hooks
The repository uses automated pre-commit hooks for:
- Trailing whitespace removal
- Large file detection
- Merge conflict detection
- Private key detection
- Executable script validation
- GitHub Actions workflow rendering

### Testing and Validation
```bash
# Validate flake structure and dependencies
nix flake check --impure --all-systems --no-build

# Check for Nix code issues
statix check .
deadnix .
```

## Language Server Configuration

The Neovim configuration includes comprehensive LSP support for:

**Core Languages**:
- **Lua**: lua-language-server with stylua formatting
- **Nix**: nixd language server with alejandra formatting
- **C/C++**: clangd with clang-format
- **Python**: python-lsp-server with flake8 linting and black formatting
- **Shell**: bash-language-server with shfmt formatting

**Web Development**:
- **HTML/CSS**: html-lsp, css-lsp with prettier formatting
- **JavaScript/TypeScript**: deno, ts_ls with eslint linting
- **Vue**: Vue TypeScript plugin integration
- **Emmet**: Emmet language server for HTML/CSS shortcuts

**Data Formats**:
- **YAML**: yaml-language-server
- **TOML**: taplo language server
- **XML**: xmlformatter

### LSP Key Bindings (via Lspsaga)
- `gh`: Find references
- `<leader>ca`: Code actions
- `gr`: Rename symbol
- `gp`: Peek definition
- `gd`: Go to definition
- `gt`: Peek type definition
- `<leader>dl`: Show line diagnostics
- `<leader>dw`: Show workspace diagnostics
- `<leader>k`: Hover documentation
- `<leader>o`: Toggle outline

## Theme and UI Configuration

**Theme**: "gatekeeper" with transparency enabled
**Integrations**: Git, completion, indent guides
**Statusline**: Round separator style
**Terminal**: Shows line numbers and relative numbers

## Deployment

This configuration is designed for deployment via:
- **nix4nvchad**: Home-manager module for NixOS systems
- **OS-nixCfg**: Parent NixOS configuration repository

The configuration integrates with the broader NixOS ecosystem and follows declarative configuration principles.
