vim.o.hlsearch = true

vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

-- Split to below and right by default
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtab = 4
vim.o.expandtab = true

vim.opt.list = true
vim.opt.listchars:append { extends = "›", precedes = "‹", eol = "⏎", trail = "·", nbsp = "⎵", space = " " }

vim.o.mousemoveevent = true
