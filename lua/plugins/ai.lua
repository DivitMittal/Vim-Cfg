-- AI-powered coding assistance plugins
local isVSCode = vim.g.vscode

return {
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
  --                   Disabled Plugins
  -- ----------------------------------------------------------- --
  -- Copilot Chat Interface
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
}
