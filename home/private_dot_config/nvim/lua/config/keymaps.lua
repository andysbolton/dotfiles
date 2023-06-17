-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move lines up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { silent = true })
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { silent = true })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true })

-- Insert newlines without entering insert mode
vim.keymap.set("n", "<leader>o", "o<Esc>k", { silent = true })
vim.keymap.set("n", "<leader>O", "O<Esc>k", { silent = true })

-- Leader +w to save the file
-- vim.keymap.set("n", "<leader>w", ":w<cr>", opts)
-- vim.keymap.set("n", "<leader>wz", ":wq!<cr>", opts)
--
vim.keymap.set("n", "<leader>t", ":split term:///usr/bin/fish<cr> | :set nonumber<cr>i", { silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
