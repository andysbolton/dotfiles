let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set tabstop=4
set shiftwidth=4
set expandtab

inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'khaveesh/vim-fish-syntax'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

lua << EOF
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()
EOF

:NvimTreeToggle
