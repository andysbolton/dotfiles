-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch        = false

-- Make line numbers default
vim.wo.number         = true

-- Enable mouse mode
vim.o.mouse           = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard       = 'unnamedplus'

-- Enable break indent
vim.o.breakindent     = true

-- Save undo history
vim.o.undofile        = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase      = true
vim.o.smartcase       = true

-- Keep signcolumn on by default
vim.wo.signcolumn     = 'yes'

-- Decrease update time
vim.o.updatetime      = 250
vim.o.timeout         = true
vim.o.timeoutlen      = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt     = 'menuone,noselect'

vim.o.termguicolors   = true

-- Split to below and right by default
vim.o.splitbelow      = true
vim.o.splitright      = true

-- Keymaps for vim-visual-multi
vim.g.VM_theme        = 'iceblue'
vim.g.VM_maps         = {}
vim.g.VM_maps["Undo"] = 'u'
vim.g.VM_maps["Redo"] = '<C-r>'
