-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.set("n", "j", "gj", { desc = "Move down visual line" })
vim.keymap.set("n", "k", "gk", { desc = "Move up visual line" })
