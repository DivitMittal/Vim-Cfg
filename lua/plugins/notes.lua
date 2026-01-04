-- Note-taking and markdown plugins
local isVSCode = vim.g.vscode

return {
  -- Image rendering in Neovim
  {
    "3rd/image.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    build = false,
    opts = {
      processor = "magick_cli",
    },
  },

  -- Image pasting from clipboard
  {
    "HakonHarnes/img-clip.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    opts = {
      default = {
        relative_to_current_file = true,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
      },
    },
    keys = {
      { "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
  },

  -- Markdown preview
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    opts = {
      file_types = { "markdown", "codecompanion", "vimwiki" },

      heading = {
        icons = { "◉ ", "◎ ", "◆ ", "◇ ", "● ", "○ " },
        min_width = { 100, 70, 60, 50, 40, 30 },
        border = { true, false, false, false, false, false },
        above = "═",
        below = "═",
      },

      pipe_table = {
        preset = "round",
      },

      on = {
        attach = function()
          vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#89DDFF", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#1A2730", fg = "#89DDFF" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH1Border", { fg = "#BD93F9", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#FFB86C", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#2A2318", fg = "#FFB86C" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#F1FA8C", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#252619", fg = "#F1FA8C" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#8AFF80" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#1A2518", fg = "#8AFF80" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#6AD6D6" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#182525", fg = "#6AD6D6" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#8896D6" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#1A1D2B", fg = "#8896D6" })
          vim.api.nvim_set_hl(0, "RenderMarkdownInlineHighlight", { fg = "#FF79C6", bg = "#2E1A26" })
          vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#50D0FF", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#FF6B6B", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#50FA7B", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#FFB86C", bold = true })
          vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = "#BD93F9", bold = true, bg = "#1A1825" })
          vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = "#6AD6D6" })
          vim.api.nvim_set_hl(0, "RenderMarkdownTableFill", { fg = "#44475A" })
        end,
      },
    },
  },

  -- Zettelkasten note-taking
  {
    "zk-org/zk-nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    ft = { "markdown" },
    config = function()
      require("zk").setup {}
    end,
  },

  -- ----------------------------------------------------------- --
  --                   Disabled Plugins
  -- ----------------------------------------------------------- --
  -- Automated Markdown bullets
  -- {
  --   "bullets-vim/bullets.vim",
  --   enabled = false,
  --   cond = not isVSCode,
  --   lazy = true,
  --   event = "BufEnter",
  --   init = function()
  --     vim.g.bullets_enabled_filetypes = { "markdown", "text", "gitcommit" }
  --     vim.g.bullets_enable_in_empty_buffers = 1
  --   end,
  -- },
}
