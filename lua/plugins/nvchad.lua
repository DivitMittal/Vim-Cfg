-- NvChad default plugins and configuration overrides
local isVSCode = vim.g.vscode

return {
  -- ----------------------------------------------------------- --
  --                   Default Plugins
  -- ----------------------------------------------------------- --
  {
    "NvChad/NvChad",
    enabled = true,
    cond = not isVSCode,
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  -- ----------------------------------------------------------- --
  --                   Overrides
  -- ----------------------------------------------------------- --
  -- file explorer/navigation
  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    cond = not isVSCode,
    opts = {
      git = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    enabled = true,
    cond = not isVSCode,
    cmd = { "ConformInfo" },
    opts = function(_, _)
      return require "configs.conform_opts"
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        mode = { "n", "v" },
        "<leader>fm",
        function()
          require("conform").format { async = true }
        end,
        desc = "Format buffer",
      },
    },
  },

  -- configure the neovim native LSP client
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    cond = not isVSCode,
    config = function()
      require "configs.lsp_config"
    end,
  },

  -- treesitter syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    cond = not isVSCode,
    opts = require "configs.treesitter_opts",
    config = function(_, opts)
      require("nvim-treesitter.install").compilers = { "clang" }
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require "configs.cmp_config"
    end,
  },

  -- ----------------------------------------------------------- --
  --                   Disabled Plugins
  -- ----------------------------------------------------------- --
  -- LSPs, DAPs, Linters & Formatters Packages Management
  -- {
  --   "williamboman/mason.nvim",
  --   enabled = false,
  --   cond = not isVSCode,
  --   -- automatic setup of lspconfig for Mason installed LSPs
  --   dependencies = {
  --     "williamboman/mason-lspconfig.nvim",
  --     enabled = false,
  --     cond = not isVSCode,
  --     config = function()
  --       require("mason-lspconfig").setup()
  --       require("mason-lspconfig").setup_handlers({
  --         function(server_name)
  --           require("lspconfig")[server_name].setup({})
  --         end,
  --       })
  --     end,
  --   },
  -- },
}
