-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- try this: vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

opt.ignorecase = true
-- pandoc related

opt.spell = false
opt.foldmethod = "manual"
opt.foldenable = false

opt.termguicolors = true
-- scrolling
opt.number = false
opt.relativenumber = true
opt.scrolloff = 8
opt.linebreak = true

vim.g.mkdp_browser = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"

-- Endringer av DBUI
-- vim.g.db_ui_win_position = "right"
-- vim.g.db_ui_show_help = 0
