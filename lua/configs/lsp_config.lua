local chadlsp = require "nvchad.configs.lspconfig"
local map = vim.keymap.set

chadlsp.defaults()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local function opts(desc)
      return { buffer = args.buf, desc = "LSP " .. desc }
    end

    map("n", "gd", "<cmd>Lspsaga goto_definition<cr>", opts "Lspsaga goto definition")
    map("n", "gp", "<cmd>Lspsaga peek_definition<cr>", opts "Lspsaga peek definition")
    map("n", "gt", "<cmd>Lspsaga peek_type_definition<cr>", opts "Lspsaga peek type definition")
    map("n", "<leader>k", "<cmd>Lspsaga hover_doc<cr>", opts "Lspsaga hover doc")

    map("n", "gh", "<cmd>Lspsaga finder<cr>", opts "Lspsaga finder")
    map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts "Lspsaga code action")
    map("n", "gr", "<cmd>Lspsaga rename<cr>", opts "Lspsaga rename")

    map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts "Lspsaga show line diagnostics")
    map("n", "<leader>dw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", opts "Lspsaga show workspace diagnostics")
    map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", opts "Lspsaga show cursor diagnostics")

    map("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", opts "Lspsaga incoming calls")
    map("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", opts "Lspsaga outgoing calls")

    map("n", "<leader>o", "<cmd>Lspsaga outline<cr>", opts "Lspsaga outline")
  end,
})

local servers = {
  -- vscode-langservers-extracted
  "html",
  "cssls",
  "jsonls",
  "eslint",

  "svelte",
  "ts_ls",
  "emmet_language_server",
  "hls",
  "pylsp",
  "lua_ls",
  "bashls",
  "nixd",
  "clangd",
  "sourcekit" -- swift
}

vim.lsp.config("emmet_language_server", {
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
})

vim.lsp.config("ts_ls", {
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
})

vim.lsp.config("hls", {
  filetypes = { "haskell", "lhaskell", "cabal" },
})

vim.lsp.config("pylsp", {
  configurationSources = { "flake8" },
  settings = {
    plugins = {
      flake8 = {
        enabled = true,
        maxLineLength = 120,
      },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      pylint = { enabled = false },
      mccabe = { enabled = false },
    },
  },
})

vim.lsp.enable(servers)
