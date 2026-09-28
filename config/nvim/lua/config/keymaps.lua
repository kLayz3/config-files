-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<C-e>", "<C-o>de")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")

vim.keymap.set("n", "<C-l>", "<C-Right>")
vim.keymap.set("n", "<C-h>", "<C-Left>")
vim.keymap.set("n", "T", ":tabnew<CR>")
vim.keymap.set("n", "<F3>", "/MARK<CR>")
vim.keymap.set("n", "<F4>", "?MARK<CR>")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- Yay, neovim's buffer vs. window distinction. Like holy fucking shit,
-- why is this a thing in 2026? If I close a window, means I'm fucking done
-- with the file, no point keeping it buffered?
local function quit_and_delete_buffer(force)
  local buffer = vim.api.nvim_get_current_buf()
  local window = vim.api.nvim_get_current_win()

  -- Delete the buffer first. If it is displayed in other windows,
  -- those windows will also lose it.
  vim.api.nvim_buf_delete(buffer, {
    force = force,
  })

  -- Now close the window from which the command was invoked.
  if vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_win_call(window, function()
      vim.cmd(force and "quit!" or "quit")
    end)
  end
end

vim.api.nvim_create_user_command("QuitDelete", function(options)
  quit_and_delete_buffer(options.bang)
end, {
  bang = true,
  desc = "Delete current buffer and close current window",
})

-- Make literal :q and :q! invoke :QuitDelete and :QuitDelete!.
vim.cmd([[
  cnoreabbrev <expr> q
  \ getcmdtype() ==# ':' && getcmdline() ==# 'q'
  \ ? 'QuitDelete'
  \ : 'q'
]])
