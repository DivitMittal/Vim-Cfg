local isVSCode = vim.g.vscode -- set by vscode neovim extension

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

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      require "configs.cmp_config"
    end,
  },

  -- ----------------------------------------------------------- --
  --                   Custom Plugins
  -- ----------------------------------------------------------- --
  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example

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
        ["tabstop"] = "detected", -- If the option value is 'detected', The value is set to the automatically detected indent size.
        ["softtabstop"] = "detected",
        ["shiftwidth"] = "detected",
      },
    },
  },

  -- Collection of nvim plugins
  {
    "echasnovski/mini.nvim",
    enabled = true,
    lazy = true,
    event = "BufEnter",
    config = function()
      -- require('mini.jump2d').setup({ labels = 'oienarstwqyxcpl' }) -- EasyMotion/Hop like plugin ( using flash.nvim instead )
      require("mini.align").setup {} -- vim-easy-align like plugin
      require("mini.surround").setup {} -- vim-surround lke plugin

      -- vim-move like plugin
      require("mini.move").setup {
        mappings = {
          -- Move visual selection in Visual mode.
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

  -- vim-seek/vim-sneak/lightspeed.nvim/mini-jump.nvim/leap.nvim like plugin for multi-charater searching & jumping
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
      -- {
      --   mode = { "o", "x" },
      --   "r",
      --   function()
      --     require("flash").treesitter_search()
      --   end,
      --   desc = "treesitter search",
      -- },
      -- {
      --   mode = { "c" },
      --   "<c-s>",
      --   function()
      --     require("flash").toggle()
      --   end,
      --   desc = "toggle flash search",
      -- },
      -- {
      --   mode = "o",
      --   "r",
      --   function()
      --     require("flash").remote()
      --   end,
      --   desc = "Remote Flash",
      -- },
    },
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
        desc = "move   cursor left  across splits",
      },
      {
        mode = { "n" },
        "<C-Right>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "move   cursor right across splits",
      },
      {
        mode = { "n" },
        "<C-Down>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "move   cursor down  across splits",
      },
      {
        mode = { "n" },
        "<C-Up>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "move   cursor up    across splits",
      },
      {
        mode = { "n" },
        "<A-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "resize pane   up    across splits",
      },
      {
        mode = { "n" },
        "<A-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "resize pane   down  across splits",
      },
      {
        mode = { "n" },
        "<A-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "resize pane   right across splits",
      },
      {
        mode = { "n" },
        "<A-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "resize pane   left  across splits",
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
    },
  },

  -- vim-vinegar like plugin for filesystem manipulation (using yazi.nvim)
  {
    "stevearc/oil.nvim",
    enabled = false,
    cond = not isVSCode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    cmd = "Oil",
    opts = {},
    keys = {
      { mode = { "n" }, "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
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
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- ----------------------------------------------------------- --
  --                Notes Plugins
  -- ----------------------------------------------------------- --
  -- Image rendering in Neovim
  {
    "3rd/image.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    build = false, -- prevents building the rock
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
        -- left_margin = { 0, 1, 2, 3, 4, 5 },
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
  --                REPL Plugins
  -- ----------------------------------------------------------- --
  -- Interactive REPL for TidalCycles and other languages
  {
    "Vigemus/iron.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    ft = { "tidal", "haskell", "python", "lua" },
    config = function()
      local iron = require "iron.core"

      iron.setup {
        config = {
          -- Whether iron should always position the repl window with a vertical split
          scratch_repl = true,

          repl_definition = {
            haskell = {
              command = { "tidal-repl" },
            },
            python = {
              command = { "python3" },
            },
            lua = {
              command = { "lua" },
            },
          },

          repl_open_cmd = require("iron.view").right(60),
        },

        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_paragraph = "<space>sp",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },

        ignore_blank_lines = true,
      }

      -- Add commands to switch between tidal-repl and ghci
      vim.api.nvim_create_user_command("IronUseTidal", function()
        iron.config.repl_definition.haskell = { command = { "tidal-repl" } }
        print "Haskell REPL set to: tidal-repl"
      end, { desc = "Use tidal-repl for Haskell" })

      vim.api.nvim_create_user_command("IronUseGhci", function()
        iron.config.repl_definition.haskell = { command = { "ghci" } }
        print "Haskell REPL set to: ghci"
      end, { desc = "Use ghci for Haskell" })
    end,
    keys = {
      {
        mode = { "n" },
        "<leader>rs",
        "<cmd>IronRepl<cr>",
        desc = "Start REPL",
      },
      {
        mode = { "n" },
        "<leader>rr",
        "<cmd>IronRestart<cr>",
        desc = "Restart REPL",
      },
      {
        mode = { "n" },
        "<leader>rf",
        "<cmd>IronFocus<cr>",
        desc = "Focus REPL",
      },
      {
        mode = { "n" },
        "<leader>rh",
        "<cmd>IronHide<cr>",
        desc = "Hide REPL",
      },
    },
  },

  -- ----------------------------------------------------------- --
  --                AI Plugins
  -- ----------------------------------------------------------- --
  -- Copilot Autocomplete
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      filetypes = {
        markdown = false,
        text = false,
        ["."] = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 100,
        keymap = {
          accept = "<M-a>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-n>",
          prev = "<M-p>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        layout = {
          position = "top",
          ratio = 0.4,
        },
        keymap = {
          accept = "<CR>",
          refresh = "gr",
        },
      },
    },
    keys = {
      {
        mode = { "n", "v" },
        "<leader>cp",
        function()
          require("copilot.panel").toggle()
        end,
        desc = "toggle copilot panel",
      },
    },
  },

  -- CodeCompanion.nvim - AI-powered coding companion
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-sonnet-4.5",
              },
            },
          })
        end,
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            commands = {
              default = {
                "gemini",
                "--experimental-acp",
                "--yolo",
                "-m",
                "gemini-3-pro-preview",
              },
            },
            defaults = {
              auth_method = "oauth-personal",
            },
          })
        end,
        opencode = function()
          return require("codecompanion.adapters").extend("opencode", {
            commands = {
              default = {
                "opencode",
                "acp",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      display = {
        chat = {
          show_token_count = true,
        },
        action_palette = {
          provider = "default",
        },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "codecompanion: actions" },
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "codecompanion: toggle chat" },
      { "<leader>ae", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "codecompanion: add to chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "codecompanion: inline prompt" },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.cmd [[cab cc CodeCompanion]]
    end,
  },

  -- ----------------------------------------------------------- --
  --                Custom Disabled Plugins
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
  --
  -- -- Copilot Chat Interface
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   enabled = false,
  --   cond = not isVSCode,
  --   lazy = true,
  --   cmd = { "CopilotChat" },
  --   build = "make tiktoken", -- Only on MacOS or Linux
  --   dependencies = {
  --     "zbirenbaum/copilot.lua",
  --     "nvim-lua/plenary.nvim", -- for curl, log and async functions
  --   },
  --   opts = {},
  -- },
  --
  -- -- multicursors.nvim & hydra.nvim(custom keybinding creation)
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
  --
  -- -- Linting
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
