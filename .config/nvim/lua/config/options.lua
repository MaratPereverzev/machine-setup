-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = true
opt.clipboard = "unnamedplus"

-- Indentation: 4 spaces
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

vim.g.have_nerd_font = true

-- Explicit picker: both fzf and telescope extras are enabled in lazyvim.json;
-- without this, extras fight over vim.g.lazyvim_picker ("auto").
vim.g.lazyvim_picker = "fzf"
