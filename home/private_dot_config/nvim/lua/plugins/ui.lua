---@diagnostic disable: missing-fields
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.keymap.set("n", "<leader><tab>", ":BufferLineCycleNext<cr>", { desc = "Cycle to next tab", silent = true })
      vim.keymap.set(
        "n",
        "<leader><s-tab>",
        ":BufferLineCyclePrev<cr>",
        { desc = "Cycle to previous tab", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>bd",
        ":bp<bar>sp<bar>bn<bar>bd!<CR>",
        { desc = "Delete current buffer", silent = true }
      )
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
            if buf.ordinal == i then vim.cmd("bd! " .. buf.id) end
          end
        end, { desc = "[B]uffer: [d]elete " .. i })
      end

      require("bufferline").setup {
        options = {
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
      theme = "tokyonight-storm",
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd [[colorscheme tokyonight-storm]] end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "tokyonight-storm",
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
        "<leader>swh",
        function() require("smart-splits").swap_buf_left() end,
        mode = { "n", "t" },
        desc = "[S][w]ap buffer left",
      },
      {
        "<leader>swj",
        function() require("smart-splits").swap_buf_down() end,
        mode = { "n", "t" },
        desc = "[S][w]ap buffer down",
      },
      {
        "<leader>swk",
        function() require("smart-splits").swap_buf_up() end,
        mode = { "n", "t" },
        desc = "[S][w]ap buffer up",
      },
      {
        "<leader>swl",
        function() require("smart-splits").swap_buf_right() end,
        mode = { "n", "t" },
        desc = "[S][w]ap buffer right",
      },
      {
        "<C-h>",
        function() require("smart-splits").move_cursor_left() end,
        mode = { "n", "t" },
      },
      {
        "<C-j>",
        function() require("smart-splits").move_cursor_down() end,
        mode = { "n", "t" },
      },
      {
        "<C-k>",
        function() require("smart-splits").move_cursor_up() end,
        mode = { "n", "t" },
      },
      {
        "<C-l>",
        function() require("smart-splits").move_cursor_right() end,
        mode = { "n", "t" },
      },
    },
  },

  { "stevearc/stickybuf.nvim", config = true },

  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      { "junegunn/fzf", config = function() vim.fn["fzf#install"]() end },
    },
    ft = "qf",
    config = function()
      local fn = vim.fn

      function _G.qftf(info)
        local items
        local ret = {}
        -- The name of item in list is based on the directory of quickfix window.
        -- Change the directory for quickfix window make the name of item shorter.
        -- It's a good opportunity to change current directory in quickfixtextfunc :)
        --
        -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
        -- local root = getRootByAlterBufnr(alterBufnr)
        -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
        --
        if info.quickfix == 1 then
          items = fn.getqflist({ id = info.id, items = 0 }).items
        else
          items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end
        local limit = 31
        local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
        local validFmt = "%s │%5d:%-3d│%s %s"
        for i = info.start_idx, info.end_idx do
          local e = items[i]
          local fname = ""
          local str
          if e.valid == 1 then
            if e.bufnr > 0 then
              fname = fn.bufname(e.bufnr)
              if fname == "" then
                fname = "[No Name]"
              else
                fname = fname:gsub("^" .. vim.env.HOME, "~")
              end
              -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
              if #fname <= limit then
                fname = fnameFmt1:format(fname)
              else
                fname = fnameFmt2:format(fname:sub(1 - limit))
              end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
          else
            str = e.text
          end
          table.insert(ret, str)
        end
        return ret
      end

      vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

      -- Adapt fzf's delimiter in nvim-bqf
      require("bqf").setup {
        filter = {
          fzf = {
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
          },
        },
      }
    end,
  },

  -- "wfxr/minimap.vim",
  -- {
  --   "Isrothy/neominimap.nvim",
  --   version = "v3.*.*",
  --   enabled = true,
  --   lazy = false, -- NOTE: NO NEED to Lazy load
  --   -- Optional
  --   keys = {
  --     -- Global Minimap Controls
  --     { "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
  --     { "<leader>no", "<cmd>Neominimap on<cr>", desc = "Enable global minimap" },
  --     { "<leader>nc", "<cmd>Neominimap off<cr>", desc = "Disable global minimap" },
  --     { "<leader>nr", "<cmd>Neominimap refresh<cr>", desc = "Refresh global minimap" },
  --
  --     -- Window-Specific Minimap Controls
  --     { "<leader>nwt", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
  --     { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
  --     { "<leader>nwo", "<cmd>Neominimap winOn<cr>", desc = "Enable minimap for current window" },
  --     { "<leader>nwc", "<cmd>Neominimap winOff<cr>", desc = "Disable minimap for current window" },
  --
  --     -- Tab-Specific Minimap Controls
  --     { "<leader>ntt", "<cmd>Neominimap tabToggle<cr>", desc = "Toggle minimap for current tab" },
  --     { "<leader>ntr", "<cmd>Neominimap tabRefresh<cr>", desc = "Refresh minimap for current tab" },
  --     { "<leader>nto", "<cmd>Neominimap tabOn<cr>", desc = "Enable minimap for current tab" },
  --     { "<leader>ntc", "<cmd>Neominimap tabOff<cr>", desc = "Disable minimap for current tab" },
  --
  --     -- Buffer-Specific Minimap Controls
  --     { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
  --     { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
  --     { "<leader>nbo", "<cmd>Neominimap bufOn<cr>", desc = "Enable minimap for current buffer" },
  --     { "<leader>nbc", "<cmd>Neominimap bufOff<cr>", desc = "Disable minimap for current buffer" },
  --
  --     ---Focus Controls
  --     { "<leader>nf", "<cmd>Neominimap focus<cr>", desc = "Focus on minimap" },
  --     { "<leader>nu", "<cmd>Neominimap unfocus<cr>", desc = "Unfocus minimap" },
  --     { "<leader>ns", "<cmd>Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
  --   },
  --   init = function()
  --     vim.opt.wrap = false
  --     vim.opt.sidescrolloff = 36 -- Set a large value
  --
  --     vim.g.neominimap = {
  --       auto_enable = true,
  --     }
  --   end,
  -- },
  -- {
  --   "petertriho/nvim-scrollbar",
  --   config = true,
  -- },
}
