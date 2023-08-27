vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move lines up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { silent = true, desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move line down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move line up" })

-- Insert newlines without entering insert mode
vim.keymap.set("n", "<leader>o", "o<Esc>k", { silent = true })
vim.keymap.set("n", "<leader>O", "O<Esc>k", { silent = true })
vim.keymap.set("n", "<leader>t", ":split term://pwsh<cr> | :set nonumber<cr> | :set norelativenumber<cr>i",
    { silent = true })

-- Exit terminal mode with <Esc>
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- Delete to black hole register
vim.keymap.set({ 'n', 'v' }, '<leader>dd', '"_dd', { silent = true })

vim.keymap.set("n", "<leader>xx", ":source %<cr>", { silent = true })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

-- Resize with arrows
vim.keymap.set("n", "<S-Down>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<S-Up>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", { silent = true })

-- Workaround to write and close all buffers when one or more is a terminal
-- https://github.com/neovim/neovim/issues/14061
vim.keymap.set("n", "<leader>xa", ":wa | qa<cr>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true })

-- Select all text
vim.keymap.set("n", "<C-a>", ":normal gg0vG$<cr>", { desc = "Select all text" })
