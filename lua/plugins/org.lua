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
      -- Same keys, targets and bodies as `org-capture-templates` in emacs-Cfg, so either editor
      -- captures into the same place. %U (date + time) rather than %u: when a thought was
      -- recorded matters as much as the thought.
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:",
          target = orgDir .. "/inbox.org",
        },
        n = {
          description = "Note",
          template = "* %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:",
          target = orgDir .. "/inbox.org",
        },
        -- Interstitial log: one line whenever focus changes; this is the "what did I actually do"
        j = {
          description = "Journal",
          template = "* %U %?",
          target = orgDir .. "/journal.org",
          datetree = { tree_type = "day" },
        },
        r = {
          description = "Reply to someone",
          template = "* TODO Reply to %^{Who}%?\n  DEADLINE: %^{Reply by}t\n  :PROPERTIES:\n  :CREATED: %U\n  :END:",
          target = orgDir .. "/people.org",
        },
        -- Doom clocks in automatically (:clock-in); nvim-orgmode has no equivalent, so clock in
        -- by hand with <leader>Oxi after finishing the capture
        c = {
          description = "Clocked work",
          template = "* STRT %^{Working on}\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %?",
          target = orgDir .. "/journal.org",
          datetree = { tree_type = "day" },
        },
      },
      org_agenda_custom_commands = {
        -- Morning view: today's schedule, what's in progress, and who/what is blocking
        d = {
          description = "Daily",
          types = {
            { type = "agenda", org_agenda_span = "day", org_agenda_overriding_header = "Today" },
            { type = "tags_todo", match = "/STRT", org_agenda_overriding_header = "In progress" },
            { type = "tags_todo", match = "/WAIT", org_agenda_overriding_header = "Waiting on" },
          },
        },
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
