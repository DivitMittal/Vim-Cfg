-- AI-powered coding assistance plugins
local isVSCode = vim.g.vscode

-- Prose/journaling filetypes where Copilot stays off unless opted in per buffer.
-- "" covers unnamed scratch buffers, which have no filetype.
local notes_filetypes = { "", "markdown", "text", "org", "norg", "asciidoc", "vimwiki", "mail" }

-- Evaluated by copilot.lua each time it decides whether to attach to a buffer
local function notes_opted_in()
  return vim.b.copilot_notes_enabled == true
end

local copilot_filetypes = { ["."] = false }
for _, ft in ipairs(notes_filetypes) do
  copilot_filetypes[ft] = notes_opted_in
end

local function toggle_copilot_notes()
  local client = require "copilot.client"
  if not vim.tbl_contains(notes_filetypes, vim.bo.filetype) then
    vim.notify("Copilot: not a notes buffer (use :Copilot toggle instead)", vim.log.levels.WARN)
    return
  end
  vim.b.copilot_notes_enabled = not notes_opted_in()
  if vim.b.copilot_notes_enabled then
    client.buf_attach(true)
  else
    client.buf_detach_if_attached()
  end
  vim.notify("Copilot for this notes buffer: " .. (vim.b.copilot_notes_enabled and "on" or "off"))
end

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
      filetypes = copilot_filetypes,
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
      {
        "<leader>cn",
        toggle_copilot_notes,
        desc = "toggle copilot in notes buffer",
      },
    },
  },

  -- CodeCompanion.nvim - AI-powered coding companion
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    -- no startup event: it would drag copilot.lua (and its node server) into every session
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    opts = {
      adapters = {
        http = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4.5",
                },
              },
            })
          end,
        },
        acp = {
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
        },
      },
      interactions = {
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
    -- defined in init so `:cc` exists before the plugin loads (expanding it triggers the cmd lazy-load)
    init = function()
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
