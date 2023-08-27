return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
    priority = 900,
    opts = {
      options = {
        -- mode = "tabs",
        close_command = "bdelete! %d | bp",
        separator_style = 'slant',
        buffer_close_icon = '✕',
        indicator = {
          icon = ''
        },
        offsets = {
          {
            filetype = "neo-tree",
          }
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' }
        }
      }
    }
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = 'tokyonight'
    }
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        extensions = { 'lazy' },
        disabled_filetypes = { 'neo-tree' }
      }
    }
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    config = function()
      require('indent_blankline').setup {
        char = '┊',
        show_end_of_line = true,
        space_char_blankline = " ",
        -- show_current_context = true,
        -- show_current_context_start = true,
      }
      vim.cmd [[highlight IndentBlanklineSpaceChar guifg=nocombine gui=nocombine]]
    end,
  },
}
