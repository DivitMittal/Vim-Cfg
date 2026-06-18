---
description: Vanilla Vim vimscript configuration deployed via OS-nixCfg
applyTo: "vim/**"
---

## Vanilla Vim Configuration

`vim/vimrc` is a traditional vimscript configuration for vanilla Vim (not Neovim). It is intentionally kept separate from the Lua config — the two editors share no configuration.

### Rules

- **Self-contained**: do not `source` external files or rely on a runtime path beyond what OS-nixCfg provides.
- **No plugin assumptions**: only assume plugins that OS-nixCfg explicitly installs for Vim. Do not reference Neovim-only APIs (`vim.fn`, `nvim_*`, Lua blocks).
- **No Lua**: this file is pure vimscript. Keep it compatible with Vim 8+.
- Deployed via the OS-nixCfg home-manager configuration — changes here take effect after a home-manager switch on the target system.

### When to edit

Make changes here only for Vim-specific behavior. If a setting applies to both editors, configure it separately in each place — do not share or generate from a common source.
