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
      require("zk").setup {
        -- Picker for selecting notes (telescope, fzf, fzf_lua, minipick, or "select")
        picker = "telescope",

        -- LSP integration for autocompletion, hover, go-to-definition, etc.
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
            on_attach = function(client, bufnr)
              -- Custom LSP keybindings specific to zk
              local bufopts = { buffer = bufnr, silent = true }

              -- Link management
              vim.keymap.set("n", "<CR>", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
              vim.keymap.set("i", "[[", "[[", bufopts) -- Trigger LSP completion for links
            end,
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      }

      -- Custom commands for common workflows
      local commands = require "zk.commands"

      -- Find orphaned notes (notes with no incoming links)
      commands.add("ZkOrphans", function(options)
        options = vim.tbl_extend("force", { orphan = true }, options or {})
        require("zk").edit(options, { title = "Orphan Notes" })
      end)

      -- Recently modified notes
      commands.add("ZkRecents", function(options)
        options = vim.tbl_extend("force", { sort = { "modified" }, limit = 15 }, options or {})
        require("zk").edit(options, { title = "Recent Notes" })
      end)

      -- Notes modified today
      commands.add("ZkToday", function(options)
        options = vim.tbl_extend("force", { createdAfter = "today" }, options or {})
        require("zk").edit(options, { title = "Today's Notes" })
      end)

      -- Notes by tag
      commands.add("ZkByTag", function(options)
        local tag = vim.fn.input "Tag: "
        if tag ~= "" then
          options = vim.tbl_extend("force", { tags = { tag } }, options or {})
          require("zk").edit(options, { title = "Notes tagged #" .. tag })
        end
      end)
    end,

    keys = {
      -- Note creation
      {
        "<leader>zn",
        function()
          local title = vim.fn.input "Title: "
          if title ~= "" then
            vim.cmd("ZkNew { title = '" .. title .. "' }")
          end
        end,
        desc = "New note",
        ft = "markdown",
      },
      {
        "<leader>zN",
        function()
          local title = vim.fn.input "Title: "
          local dir = vim.fn.input "Directory: "
          if title ~= "" then
            vim.cmd("ZkNew { title = '" .. title .. "', dir = '" .. dir .. "' }")
          end
        end,
        desc = "New note in directory",
        ft = "markdown",
      },
      {
        "<leader>zd",
        "<cmd>ZkNew { title = vim.fn.strftime('%Y-%m-%d'), dir = 'daily' }<cr>",
        desc = "Daily note",
        ft = "markdown",
      },

      -- Note discovery
      { "<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", desc = "Open notes", ft = "markdown" },
      {
        "<leader>zf",
        function()
          local search = vim.fn.input "Search: "
          if search ~= "" then
            vim.cmd("ZkNotes { sort = { 'modified' }, match = { '" .. search .. "' } }")
          end
        end,
        desc = "Find notes by content",
        ft = "markdown",
      },
      { "<leader>zt", "<cmd>ZkTags<cr>", desc = "Browse tags", ft = "markdown" },
      { "<leader>zT", "<cmd>ZkByTag<cr>", desc = "Notes by tag", ft = "markdown" },

      -- Link management (works with lspsaga's `gd`, `gp`, `gh`)
      { "<leader>zl", "<cmd>ZkLinks<cr>", desc = "Outgoing links", ft = "markdown" },
      { "<leader>zb", "<cmd>ZkBacklinks<cr>", desc = "Incoming links (backlinks)", ft = "markdown" },
      {
        "<leader>zi",
        ":'<,'>ZkInsertLinkAtSelection<cr>",
        desc = "Insert link from selection",
        mode = "v",
        ft = "markdown",
      },
      { "<leader>zi", "<cmd>ZkInsertLink<cr>", desc = "Insert link", mode = "n", ft = "markdown" },

      -- Custom workflows
      { "<leader>zr", "<cmd>ZkRecents<cr>", desc = "Recent notes", ft = "markdown" },
      { "<leader>zp", "<cmd>ZkOrphans<cr>", desc = "Orphan notes", ft = "markdown" },
      { "<leader>zy", "<cmd>ZkToday<cr>", desc = "Today's notes", ft = "markdown" },

      -- Context-aware note creation from visual selection
      {
        "<leader>zn",
        ":'<,'>ZkNewFromTitleSelection<cr>",
        desc = "New note from selection",
        mode = "v",
        ft = "markdown",
      },
      {
        "<leader>zc",
        ":'<,'>ZkNewFromContentSelection { dir = vim.fn.input('Directory: ') }<cr>",
        desc = "New note from content",
        mode = "v",
        ft = "markdown",
      },
    },
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
