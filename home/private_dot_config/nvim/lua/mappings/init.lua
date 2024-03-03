vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move lines up/down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { silent = true, desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move line down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move line up" })

-- Insert newlines without entering insert mode
vim.keymap.set("n", "<leader>o", "o<Esc>k", { silent = true })
vim.keymap.set("n", "<leader>O", "O<Esc>j", { silent = true })

-- Delete to black hole register
vim.keymap.set({ "n", "v" }, "<leader>dd", '"_dd<Esc>', { silent = true })
vim.keymap.set({ "v" }, "<leader>d", '"_d<Esc>', { silent = true })

-- Source current file
vim.keymap.set("n", "<leader>xx", ":source %<cr>", { silent = true, desc = "Source current file" })

-- Workaround to write and close all buffers when one or more is a terminal
-- https://github.com/neovim/neovim/issues/14061
vim.keymap.set(
  "n",
  "<leader>xa",
  ":wa | qa<cr>",
  { silent = true, desc = "Write and close all buffers while terminal open" }
)
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "[W]rite" })
vim.keymap.set("n", "<leader>wa", ":wa<cr>", { silent = true, desc = "[W]rite [A]ll" })

vim.keymap.set("n", "<C-a>", ":normal gg0vG$<cr>", { desc = "Select all text" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Copy current buffer name
vim.keymap.set("n", "<leader>c", ":let @+=expand('%')<cr>", { silent = true, desc = "[C]opy current buffer name" })
