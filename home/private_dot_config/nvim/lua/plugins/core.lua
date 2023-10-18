return {
  "tpope/vim-surround",

  {
    "folke/which-key.nvim",
    config = true,
    event = "VeryLazy",
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      local ft = require "Comment.ft"
      -- Formatting for jq files
      ft.jq = "#%s"
    end,
  },

  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function() vim.g["chezmoi#use_tmp_buffer"] = true end,
  },

  {
    "rafcamlet/nvim-luapad",
    config = true,
  },

  "tpope/vim-sensible",

  {
    "github/copilot.vim",
    config = function() vim.g.copilot_filetypes = { jq = false } end,
  },

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  "romainl/vim-cool",

  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<A-h>",
        function() require("smart-splits").resize_left() end,
        mode = { "n", "t" },
      },
      {
        "<A-l>",
        function() require("smart-splits").resize_right() end,
        mode = { "n", "t" },
      },
      {
        "<A-k>",
        function() require("smart-splits").resize_up() end,
        mode = { "n", "t" },
      },
      {
        "<A-j>",
        function() require("smart-splits").resize_down() end,
        mode = { "n", "t" },
      },
      {
        "<leader>sh",
        function() require("smart-splits").swap_buf_left() end,
        mode = { "n", "t" },
        desc = "[S]wap buffer left",
      },
      {
        "<leader>sj",
        function() require("smart-splits").swap_buf_down() end,
        mode = { "n", "t" },
        desc = "[S]wap buffer down",
      },
      {
        "<leader>sk",
        function() require("smart-splits").swap_buf_up() end,
        mode = { "n", "t" },
        desc = "[S]wap buffer up",
      },
      {
        "<leader>sl",
        function() require("smart-splits").swap_buf_right() end,
        mode = { "n", "t" },
        desc = "[S]wap buffer right",
      },
    },
  },

  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        pre_save_cmds = {
          function() require("neo-tree.sources.manager").close_all() end,
        },
        pre_restore_cmds = {
          function() require("neo-tree.sources.manager").close_all() end,
        },
        post_restore_cmds = {
          function() require("neo-tree.sources.manager").show "filesystem" end,
        },
      }
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup {}

      vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "[T]oggle [T]rouble" })

      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  {
    "ellisonleao/glow.nvim",
    opts = true,
    cmd = "Glow",
  },

  -- {
  --   "kevinhwang91/nvim-bqf",
  --   ft = "qf",
  --   opts = {},
  -- },
}
