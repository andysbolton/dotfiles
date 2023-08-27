return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      'nvim-telescope/telescope-live-grep-args.nvim'
    },
    config = require 'plugins.config.telescope'
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    {{- if eq .chezmoi.os "windows" }}
    build = 
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    cond = function()
      return vim.fn.executable 'cmake' == 1
    end,
    {{- else }}
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
    {{- end }}
  },
}
