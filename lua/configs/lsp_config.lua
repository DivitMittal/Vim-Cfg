local lspconfig = require "lspconfig"
local chadlsp = require "nvchad.configs.lspconfig"
chadlsp.defaults()

local servers = {
  -- vscode-langservers-extracted
  "html",
  "cssls",
  "jsonls",
  "eslint",

  "bashls",
  "nixd",
  "clangd",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = chadlsp.on_attach,
    on_init = chadlsp.on_init,
    capabilities = chadlsp.capabilities,
  }
end

-- html
lspconfig.emmet_language_server.setup {
  on_attach = chadlsp.on_attach,
  on_init = chadlsp.on_init,
  capabilities = chadlsp.capabilities,
  filetypes = {
    "css",
    "html",
    "eruby",
    "javascript",
    "javascriptreact",
    "htmldjango",
    "less",
    "sass",
    "scss",
    "pug",
    "typescriptreact",
    "vue",
  },
}

-- typescript
lspconfig.ts_ls.setup {
  on_attach = chadlsp.on_attach,
  on_init = chadlsp.on_init,
  capabilities = chadlsp.capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        -- it's a hack for nixOS /nix/store/
        location = vim.fs.joinpath(
          vim.fs.dirname(vim.fs.dirname(vim.fn.system "echo -n $(readlink -f $(which vue-language-server))")),
          "lib/node_modules/@vue/language-server"
        ),
        --
        languages = { "vue" },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
}

--python
lspconfig.pylsp.setup {
  on_attach = chadlsp.on_attach,
  on_init = chadlsp.on_init,
  capabilities = chadlsp.capabilities,
  configurationSources = { "flake8" },
  settings = {
    plugins = {
      flake8 = {
        enabled = true,
        maxLineLength = 80,
      },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      pylint = { enabled = false },
      mccabe = { enabled = false },
    },
  },
}

-- haskell
lspconfig.hls.setup {
  on_attach = chadlsp.on_attach,
  on_init = chadlsp.on_init,
  capabilities = chadlsp.capabilities,
  filetypes = { "haskell", "lhaskell", "cabal" },
}
