---@diagnostic disable: missing-fields
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
    config = function()
      vim.keymap.set("n", "<leader><tab>", ":BufferLineCycleNext<cr>")
      vim.keymap.set("n", "<leader><s-tab>", ":BufferLineCyclePrev<cr>")
      vim.keymap.set("n", "<leader>bd", ":Bdelete<cr>", { desc = "Delete current buffer" })
      vim.keymap.set("n", "<leader>bdr", ":BufferLineCloseRight<cr>", { desc = "Delete buffers to the right" })
      vim.keymap.set("n", "<leader>bdl", ":BufferLineCloseLeft<cr>", { desc = "Delete buffers to the left" })
      vim.keymap.set("n", "<leader>bdo", ":BufferLineCloseOthers<cr>", { desc = "Delete other buffers" })

      for i = 1, 15 do
        vim.keymap.set(
          "n",
          "<leader>b" .. i,
          ":BufferLineGoToBuffer " .. i .. "<cr>",
          { desc = "Go to [b]uffer at " .. i }
        )
        vim.keymap.set("n", "<leader>db" .. i, function()
          for _, buf in pairs(require("bufferline.buffers").get_components(require "bufferline.state")) do
            if buf.ordinal == i then vim.cmd("Bdelete! " .. buf.id) end
          end
        end, { desc = "[D]elete [b]uffer at " .. i })
      end

      require("bufferline").setup {
        options = {
          close_command = ":Bdelete %d",
          separator_style = "slant",
          buffer_close_icon = "✕",
          indicator = {
            icon = "",
          },
          offsets = {
            {
              filetype = "neo-tree",
            },
          },
          ---@diagnostic disable-next-line: undefined-field
          numbers = function(opts) return string.format("%s.%s", opts.ordinal, opts.lower(opts.id)) end,
        },
      }
    end,
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
      theme = "tokyonight",
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd [[colorscheme tokyonight-night]] end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "tokyonight",
          disabled_filetypes = { "neo-tree" },
        },
        extensions = { "lazy" },
        sections = {
          lualine_c = {
            {
              "filename",
              cond = function() return vim.bo.buftype ~= "terminal" end,
            },
          },
        },
      }
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "┊" },
    },
  },

  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
}
}
