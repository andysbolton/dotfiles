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
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>po",
        function() require("peek").open() end,
        mode = { "n" },
        desc = "[P]eek [o]pen (markdown preview)",
      },
      {
        "<leader>pc",
        function() require("peek").close() end,
        mode = { "n" },
        desc = "[P]eek [c]lose (markdown preview)",
      },
    },
    config = true,
  },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },

  {
    "williamboman/mason.nvim",
    config = true,
  },

  {
    "julienvincent/nvim-paredit",
    config = function()
      local paredit = require "nvim-paredit"
      paredit.setup {
        keys = {
          ["<localleader>wh"] = {
            function()
              -- place cursor and set mode to `insert`
              paredit.cursor.place_cursor(
                -- wrap element under cursor with `( ` and `)`
                paredit.wrap.wrap_element_under_cursor("( ", ")"),
                -- cursor placement opts
                { placement = "inner_start", mode = "insert" }
              )
            end,
            "[W]rap element insert [h]ead",
          },

          ["<localleader>wt"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_element_under_cursor("(", ")"),
                { placement = "inner_end", mode = "insert" }
              )
            end,
            "[W]rap element insert [t]ail",
          },

          -- same as above but for enclosing form
          ["<localleader>weh"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor("( ", ")"),
                { placement = "inner_start", mode = "insert" }
              )
            end,
            "[W]rap [e]nclosing form insert [h]ead",
          },

          ["<localleader>wet"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor("(", ")"),
                { placement = "inner_end", mode = "insert" }
              )
            end,
            "[W]rap [e]nclosing form insert [t]ail",
          },
        },
      }
    end,
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

  "tpope/vim-sensible",

  "github/copilot.vim",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  "romainl/vim-cool",

  {
    "rmagatti/auto-session",
    config = function()
      local function close_neo_tree() require("neo-tree.sources.manager").close_all() end

      ---@diagnostic disable-next-line: missing-fields
      require("auto-session").setup {
        log_level = "error",
        pre_save_cmds = {
          close_neo_tree,
        },
        pre_restore_cmds = {
          close_neo_tree,
        },
        post_restore_cmds = {
          function() require("neo-tree.sources.manager").show "filesystem" end,
        },
      }
      -- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "ellisonleao/glow.nvim",
    opts = true,
    cmd = "Glow",
  },

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- lsp = {
      --   code_actions = {
      --     previewer = "codeaction_native",
      --     preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
      --   },
      -- },
    },
  },

  -- {
  --   "stevearc/dressing.nvim",
  --   opts = {},
  -- },
}
