require "nvchad.autocmds"

-- ━━━━━━━━━━━━━━━━━━━❰ Filetype ❱━━━━━━━━━━━━━━━━━━━━ --
local ft = vim.filetype

ft.add {
  extension = {
    kbd = "lisp",
    tidal = "haskell",
  },
  filename = {
    [".condarc"] = "yaml",
    ["tridactylrc"] = "vim",
    ["ideavimrc"] = "vim",
  },
  pattern = {
    [".*conf"] = "ini",
  },
}

-- ━━━━━━━━━━━━━━━━━━━❰ Automate ❱━━━━━━━━━━━━━━━━━━━━ --
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("VimResized", {
  group = augroup("pane_resize", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

autocmd("TextYankPost", {
  group = augroup("yank_highlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 500, on_visual = true }
  end,
})

autocmd("BufReadPost", {
  group = augroup("jump_to_last_position", { clear = true }),
  pattern = "?*",
  callback = function()
    vim.cmd [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]
  end,
})

autocmd("BufWritePre", {
  group = augroup("remove_trailing_whitespaces", { clear = true }),
  pattern = "?*",
  callback = function(args)
    local bo = vim.bo[args.buf]
    -- markdown uses two trailing spaces as a hard line break; diffs carry meaningful whitespace
    if bo.binary or not bo.modifiable or vim.tbl_contains({ "markdown", "diff" }, bo.filetype) then
      return
    end
    -- :s leaves the cursor on the last substituted line, so restore the view
    local view = vim.fn.winsaveview()
    vim.cmd [[silent keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(view)
  end,
})

autocmd("BufReadPost", {
  group = augroup("dont_autocomment_lines", { clear = true }),
  pattern = "?*",
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

-- persist manual folds across sessions; viewoptions is narrowed to folds so views
-- neither change the cwd nor fight jump_to_last_position over the cursor
vim.opt.viewoptions = { "folds" }

local fold_views = augroup("persist_folds", { clear = true })

---@param buf integer
---@return boolean
local function has_view(buf)
  return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
end

autocmd("BufWinLeave", {
  group = fold_views,
  pattern = "?*",
  callback = function(args)
    if has_view(args.buf) then
      vim.cmd "silent! mkview"
    end
  end,
})

autocmd("BufWinEnter", {
  group = fold_views,
  pattern = "?*",
  callback = function(args)
    if has_view(args.buf) then
      vim.cmd "silent! loadview"
    end
  end,
})

-- render-markdown.nvim relies on clean whitespace rendering; listchars with
-- space/eol markers corrupt heading backgrounds and virtual text overlays.
autocmd("FileType", {
  group = augroup("markdown_options", { clear = true }),
  pattern = { "markdown", "codecompanion" },
  callback = function()
    vim.opt_local.list = false
  end,
})
