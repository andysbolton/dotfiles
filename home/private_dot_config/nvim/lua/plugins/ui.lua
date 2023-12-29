---@diagnostic disable: missing-fields
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
    config = function()
      vim.keymap.set("n", "<leader><tab>", ":BufferLineCycleNext<cr>", { desc = "Cycle to next tab", silent = true })
      vim.keymap.set(
        "n",
        "<leader><s-tab>",
        ":BufferLineCyclePrev<cr>",
        { desc = "Cycle to previous tab", silent = true }
      )
      vim.keymap.set("n", "<leader>bd", ":Bdelete<cr>", { desc = "Delete current buffer", silent = true })
      vim.keymap.set(
        "n",
        "<leader>bdr",
        ":BufferLineCloseRight<cr>",
        { desc = "Delete buffers to the right", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>bdl",
        ":BufferLineCloseLeft<cr>",
        { desc = "Delete buffers to the left", silent = true }
      )
      vim.keymap.set("n", "<leader>bdo", ":BufferLineCloseOthers<cr>", { desc = "Delete other buffers", silent = true })

      for i = 1, 15 do
        vim.keymap.set(
          "n",
          "<leader>bs" .. i,
          ":BufferLineGoToBuffer " .. i .. "<cr>",
          { desc = "[B]uffer: [s]et " .. i }
        )
        vim.keymap.set("n", "<leader>bd" .. i, function()
          for _, buf in pairs(require("bufferline.buffers").get_components(require "bufferline.state")) do
            if buf.ordinal == i then vim.cmd("Bdelete! " .. buf.id) end
          end
        end, { desc = "[B]uffer: [d]elete " .. i })
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
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("alpha").setup(require("alpha.themes.startify").config) end,
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup {
        stages = "fade_in_slide_out",
        timeout = 3000,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      }
      vim.notify = require "notify"
    end,
  },

  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     lsp = {
  --       -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --       override = {
  --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --         ["vim.lsp.util.stylize_markdown"] = true,
  --         ["cmp.entry.get_documentation"] = true,
  --       },
  --     },
  --     -- you can enable a preset for easier configuration
  --     presets = {
  --       bottom_search = true, -- use a classic bottom cmdline for search
  --       command_palette = false, -- position the cmdline and popupmenu together
  --       -- long_message_to_split = true, -- long messages will be sent to a split
  --       inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --       lsp_doc_border = true, -- add a border to hover docs and signature help
  --     },
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   },
  -- },
}
