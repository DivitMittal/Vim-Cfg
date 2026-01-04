-- Plugin specifications organized by functionality
-- All plugins are lazy-loaded by default for optimal performance

return {
  -- Import plugin modules
  { import = "plugins.nvchad" }, -- NvChad core & overrides
  { import = "plugins.general" }, -- General enhancements & LSP UI
  { import = "plugins.misc" }, -- Miscellaneous enhancements
  { import = "plugins.notes" }, -- Note-taking & markdown
  { import = "plugins.repl" }, -- REPL integration
  { import = "plugins.ai" }, -- AI-powered assistance
}
