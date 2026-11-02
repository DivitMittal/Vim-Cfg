-- Org-mode: shares its files with Doom Emacs (see emacs-Cfg/config.el)
local isVSCode = vim.g.vscode

-- Keep in sync with `org-directory` in emacs-Cfg so both editors see the same agenda and roam graph
local orgDir = "~/Sync/Vaults/Main/org"

return {
  {
    "nvim-orgmode/orgmode",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    ft = { "org" },
    opts = {
      -- Top level only, matching Doom's `org-agenda-files` default of (list org-directory)
      org_agenda_files = orgDir .. "/*.org",
      org_default_notes_file = orgDir .. "/inbox.org",
      -- Doom's default keywords; unknown ones would parse as plain heading text here
      org_todo_keywords = { "TODO", "PROJ", "LOOP", "STRT", "WAIT", "HOLD", "IDEA", "|", "DONE", "KILL" },
      org_startup_indented = true,
      org_hide_emphasis_markers = true,
      org_capture_templates = {
        t = { description = "Task", template = "* TODO %?\n  %u" },
        n = { description = "Note", template = "* %?\n  %u" },
      },
      -- The default <leader>o prefix would delay Lspsaga's <leader>o outline by timeoutlen
      mappings = { prefix = "<leader>O" },
    },
  },

  -- Heading & list bullets
  {
    "nvim-orgmode/org-bullets.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    ft = { "org" },
    dependencies = { "nvim-orgmode/orgmode" },
    opts = {},
  },

  -- Fuzzy headlines, tags, refile & link insertion
  {
    "nvim-orgmode/telescope-orgmode.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    dependencies = { "nvim-orgmode/orgmode", "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fO",
        function()
          require("telescope").extensions.orgmode.search_headings()
        end,
        desc = "Org headlines",
      },
      {
        "<leader>fT",
        function()
          require("telescope").extensions.orgmode.search_tags()
        end,
        desc = "Org tags",
      },
    },
    config = function()
      require("telescope").load_extension "orgmode"
    end,
  },

  -- Zettelkasten over org files; same node format as Emacs org-roam, so org-roam-ui graphs both
  {
    "chipsenkbeil/org-roam.nvim",
    enabled = true,
    cond = not isVSCode,
    lazy = true,
    event = "VeryLazy",
    dependencies = { "nvim-orgmode/orgmode" },
    opts = {
      directory = orgDir .. "/roam",
      -- The default <leader>n is NvChad's line-number toggle
      bindings = { prefix = "<leader>R" },
    },
  },
}
