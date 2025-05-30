local lspconfig = require "lspconfig"
local chadlsp = require "nvchad.configs.lspconfig"
local attach = function(client, bufnr)
  local map = vim.keymap.set
  chadlsp.on_attach(client, bufnr)
  -- lspsaga
  map("n", "gh", "<cmd>Lspsaga finder<cr>", { buffer = bufnr, desc = "Lspsaga finder" })
  map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", { buffer = bufnr, desc = "Lspsaga code action" })
  map("n", "gr", "<cmd>Lspsaga rename<cr>", { buffer = bufnr, desc = "Lspsaga rename" })
  map("n", "gp", "<cmd>Lspsaga peek_definition<cr>", { buffer = bufnr, desc = "Lspsaga peek definition" })
  map("n", "gd", "<cmd>Lspsaga goto_definition<cr>", { buffer = bufnr, desc = "Lspsaga goto definition" })
  map("n", "gt", "<cmd>Lspsaga peek_type_definition<cr>", { buffer = bufnr, desc = "Lspsaga peek type definition" })
  map(
    "n",
    "<leader>dl",
    "<cmd>Lspsaga show_line_diagnostics<cr>",
    { buffer = bufnr, desc = "Lspsaga show line diagnostics" }
  )
  map(
    "n",
    "<leader>dw",
    "<cmd>Lspsaga show_workspace_diagnostics<cr>",
    { buffer = bufnr, desc = "Lspsaga show workspace diagnostics" }
  )
  map(
    "n",
    "<leader>dc",
    "<cmd>Lspsaga show_cursor_diagnostics<cr>",
    { buffer = bufnr, desc = "Lspsaga show cursor diagnostics" }
  )
  map("n", "<leader>k", "<cmd>Lspsaga hover_doc<cr>", { buffer = bufnr, desc = "Lspsaga hover doc" })
  map("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", { buffer = bufnr, desc = "Lspsaga incoming calls" })
  map("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", { buffer = bufnr, desc = "Lspsaga outgoing calls" })
  map("n", "<leader>o", "<cmd>Lspsaga outline<cr>", { buffer = bufnr, desc = "Lspsaga outline" })
end

chadlsp.defaults()
local servers = {
  -- vscode-langservers-extracted
  "html",
  "cssls",
  "jsonls",
  "eslint",
  "svelte",

  "lua_ls",
  "bashls",
  "nixd",
  "clangd",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = attach,
    on_init = chadlsp.on_init,
    capabilities = chadlsp.capabilities,
  }
end

-- html
lspconfig.emmet_language_server.setup {
  on_attach = attach,
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
  on_attach = attach,
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
  on_attach = attach,
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
  on_attach = attach,
  on_init = chadlsp.on_init,
  capabilities = chadlsp.capabilities,
  filetypes = { "haskell", "lhaskell", "cabal" },
}

-- markdown-oxide
lspconfig.markdown_oxide.setup {
  on_attach = attach,
  on_init = chadlsp.on_init,
  capabilities = vim.tbl_deep_extend("force", chadlsp.capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  filetypes = { "markdown", "vimwiki" },
}