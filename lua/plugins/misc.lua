-- Miscellaneous plugins
local isVSCode = vim.g.vscode

return {
  -- Collection of nvim plugins
  {
    "echasnovski/mini.nvim",
    enabled = true,
    lazy = true,
    event = "BufEnter",
    config = function()
      require("mini.align").setup {}
      require("mini.surround").setup {}

      -- vim-move like plugin
      require("mini.move").setup {
        mappings = {
          -- Move visual selection in Visual mode
          left = "<S-Left>",
          right = "<S-Right>",
          down = "<S-Down>",
          up = "<S-Up>",
          -- Move current line in Normal mode
          line_left = "<S-Left>",
          line_right = "<S-Right>",
          line_down = "<S-Down>",
          line_up = "<S-Up>",
        },
        options = { reindent_linewise = true },
      }
    end,
  },

  -- multi-character searching & jumping
  {
    "folke/flash.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    opts = {
      labels = "tsraneiofuplwykdq",
      highlight = { backdrop = false },
      modes = {
        char = {
          enabled = true,
          highlight = { backdrop = false },
        },
        search = { enabled = false },
      },
    },
    keys = {
      {
        mode = { "n", "x", "o" },
        "<leader><cr>",
        function()
          require("flash").jump()
        end,
        desc = "flash",
      },
    },
  },

  -- manoeuvre around splits b/w multiplexers & nvim-splits
  {
    "mrjones2014/smart-splits.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "BufEnter",
    opts = {},
    keys = {
      {
        mode = { "n" },
        "<C-Left>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "move cursor left across splits",
      },
      {
        mode = { "n" },
        "<C-Right>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "move cursor right across splits",
      },
      {
        mode = { "n" },
        "<C-Down>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "move cursor down across splits",
      },
      {
        mode = { "n" },
        "<C-Up>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "move cursor up across splits",
      },
      {
        mode = { "n" },
        "<A-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "resize pane up across splits",
      },
      {
        mode = { "n" },
        "<A-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "resize pane down across splits",
      },
      {
        mode = { "n" },
        "<A-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "resize pane right across splits",
      },
      {
        mode = { "n" },
        "<A-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "resize pane left across splits",
      },
    },
  },

  -- bundle of QoL plugins
  {
    "folke/snacks.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = false,
    priority = 1000,
    opts = {
      lazygit = { enabled = true },
      terminal = { enabled = true },
    },
    keys = {
      {
        mode = { "n" },
        "<leader>lg",
        function()
          require("snacks").lazygit()
        end,
        desc = "Lazygit floating window",
      },
      {
        mode = { "n", "t" },
        "<C-/>",
        function()
          require("snacks").terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        mode = { "n", "t" },
        "<C-_>",
        function()
          require("snacks").terminal()
        end,
        desc = "which_key_ignore",
      },
    },
  },

  -- yazi.nvim
  {
    "mikavilpas/yazi.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>cw",
        mode = { "n", "v" },
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- ----------------------------------------------------------- --
  --                   Disabled Plugins
  -- ----------------------------------------------------------- --
  -- vim-vinegar like plugin for filesystem manipulation (using yazi.nvim)
  -- {
  --   "stevearc/oil.nvim",
  --   enabled = true,
  --   cond = not isVSCode,
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   event = "VeryLazy",
  --   cmd = "Oil",
  --   opts = {},
  --   keys = {
  --     { mode = { "n" }, "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
  --   },
  -- },
  --
  -- multicursors.nvim & hydra.nvim(custom keybinding creation)
  -- {
  --   "smoka7/multicursors.nvim",
  --   enabled = false,
  --   cond = not isVSCode,
  --   lazy = true,
  --   cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  --   dependencies = { "smoka7/hydra.nvim" },
  --   opts = {},
  --   keys = {
  --     {
  --       mode = { "v", "n" },
  --       "<leader>mc",
  --       "<cmd>MCstart<cr>",
  --       desc = "selected word under the cursor and listen for actions",
  --     },
  --   },
  -- },
}
