-- REPL plugins for interactive coding
local isVSCode = vim.g.vscode

return {
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
}
