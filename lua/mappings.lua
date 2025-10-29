require "nvchad.mappings"

local map = vim.keymap.set
local noremap = { noremap = true, silent = true }
local silent = { silent = true }

-- general
map("n", "//", "<cmd>nohlsearch <cr>", silent) -- clear search highlighting

-- fallbacks
map("n", "0", "^", noremap) -- start of line

-- Undo & Redo Fix for Colemak layout
map("n", "u", "<Nop>", noremap)
map("n", "U", "<cmd>undo <CR>", noremap)
map("n", "R", "<cmd>redo <CR>", noremap)
