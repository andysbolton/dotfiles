return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      lightbulb = {
        virtual_text = false
      }
    })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons'
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        'williamboman/mason.nvim',
        config = true
      },

      'williamboman/mason-lspconfig.nvim',

      -- 'hrsh7th/cmp-nvim-lsp',
      -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        tag = "legacy",
        config = true
      },

      {
        'folke/neodev.nvim',
        config = true
      }
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    config = true
  },
}
