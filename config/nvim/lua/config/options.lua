-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.mouse = "v"
vim.opt.encoding = "UTF-8"

vim.g.autoformat = false

local lsp = vim.lsp
if lsp and lsp.inlay_hint then
  lsp.inlay_hint.enable(false)
end

-- Restore Vim's default split placement
-- vim.opt.splitbelow = false
-- vim.opt.splitright = false
