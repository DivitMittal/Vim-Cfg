---
description: NvChad-based Neovim Lua configuration deployed via nix4nvchad
applyTo: "lua/**"
---

## Neovim Lua Configuration

NvChad-based Neovim config. The entry point (`init.lua`) lives at the repo root or is injected by the nix4nvchad home-manager module — it is not inside `lua/`. Everything in this directory is loaded after NvChad bootstraps.

### Top-level modules

- `chadrc.lua`: NvChad theme and UI overrides. Change the active theme, statusline, dashboard, and NvChad integrations here.
- `options.lua`: Vim options (`vim.opt.*`). Keep additions minimal — prefer plugin-specific options inside `configs/`.
- `mappings.lua`: Key bindings (`vim.keymap.set`). Global mappings only; plugin-local mappings belong in the plugin's `opts` or `config` function in `plugins/init.lua`.
- `autocmds.lua`: Autocommands (`vim.api.nvim_create_autocmd`). One logical group per autocommand group name.

### `configs/` — modular component configs

- `mason_pkgs.lua`: Source of truth for what Mason installs. Add new language tooling (LSP servers, formatters, linters) here first before wiring elsewhere.
- `lsp_config.lua`: Per-server LSP setup. Uses Lspsaga for UI. Server names must match the Mason package names used in `mason_pkgs.lua`.
- `cmp_config.lua`: nvim-cmp autocompletion sources and keymaps.
- `conform_opts.lua`: conform.nvim formatter mapping (filetype → formatter). Formatters must also be listed in `mason_pkgs.lua`.
- `lint_opts.lua`: nvim-lint linter mapping (filetype → linter). Linters must also be listed in `mason_pkgs.lua`.
- `treesitter_opts.lua`: nvim-treesitter `ensure_installed` and parser options.
- `lazy_config.lua`: lazy.nvim plugin manager settings (root dir, UI, performance).

### `plugins/init.lua`

Plugin specifications for lazy.nvim. Follow the existing spec format:

```lua
{
  "owner/repo",
  event = "BufReadPost",  -- or ft = { "lua" }, cmd = "...", etc.
  opts = { ... },         -- passed to setup(); prefer opts over config when possible
}
```

Lazy-load aggressively — use `event`, `ft`, or `cmd` triggers to keep startup time low.

### Style

Deployed via the `nix4nvchad` home-manager module. `nix fmt` runs stylua, which enforces:
- 2-space indentation
- Single-quoted strings
- No trailing whitespace

Run `nix fmt` before committing any Lua change.
