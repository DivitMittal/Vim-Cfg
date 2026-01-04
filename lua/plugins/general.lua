-- General enhancements and LSP UI plugins
local isVSCode = vim.g.vscode

return {
  -- Automatically set indentation/tabstop space size of the current buffer
  {
    "nmac427/guess-indent.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "InsertEnter",
    opts = {
      auto_cmd = true,
      override_editorconfig = false,

      filetype_exclude = {
        "tutor",
        "netrw",
      },
      buftype_exclude = {
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
      on_tab_options = {
        ["expandtab"] = false,
      },
      on_space_options = {
        ["expandtab"] = true,
        ["tabstop"] = "detected",
        ["softtabstop"] = "detected",
        ["shiftwidth"] = "detected",
      },
    },
  },

  -- Integrate with LSPs better
  {
    "nvimdev/lspsaga.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "LspAttach",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup {}
    end,
  },

  -- diagnostics
  {
    "folke/trouble.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    cmd = "Trouble",
    opts = {},
    keys = {
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>ll",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>qf",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- ----------------------------------------------------------- --
  --                   Disabled Plugins
  -- ----------------------------------------------------------- --
  -- Linting
  -- {
  --   "mfussenegger/nvim-lint",
  --   enabled = false,
  --   cond = not isVSCode,
  --   lazy = true,
  --   event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  --   opts = function(_, _)
  --     return require "configs.lint_opts"
  --   end,
  --   config = function(_, opts)
  --     local lint = require "lint"
  --     lint.linters_by_ft = opts
  --     vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  --       group = vim.api.nvim_create_augroup("lint", { clear = true }),
  --       pattern = "*",
  --       callback = function()
  --         lint.try_lint()
  --       end,
  --     })
  --   end,
  -- },
}
