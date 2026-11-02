-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@return boolean
function IsWindows()
  return vim.uv.os_uname().version:match "Windows"
end

return {
  base46 = {
    theme = "gatekeeper",
    transparency = true,
    integrations = {
      "git",
      "cmp",
      "blankline",
    },
    -- highlights
    hl_override = {
      Comment = { italic = true },
    },
    hl_add = {
      NvimTreeOpenedFolderName = { fg = "green", bold = true },
    },
  },

  ui = {
    statusline = {
      separator_style = "round",
    },
  },

  nvdash = {
    load_on_startup = false,
  },

  cheatsheet = {
    theme = "grid",
  },

  term = {
    winopts = {
      number = true,
      relativenumber = true,
    },
  },

  mason = {
    cmd = IsWindows(),
    pkgs = require "configs.mason_pkgs",
  },
}
