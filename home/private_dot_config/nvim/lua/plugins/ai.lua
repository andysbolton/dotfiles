return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          keymap = {
            jump_prev = "N",
            jump_next = "n",
          },
        },
        suggestion = {
          keymap = {
            accept = "<M-j>",
          },
          auto_trigger = true,
          layout = {
            position = "right",
            ratio = 0.4,
          },
        },
        filetypes = {
          yaml = true,
        },
      }
    end,
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function() require("copilot_cmp").setup() end,
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim", branch = "master" },
  --   },
  --   build = "make tiktoken",
  --   opts = {
  --     -- See Configuration section for options
  --   },
  -- },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        -- strategies = {
        --   chat = {
        --     adapter = "anthropic",
        --   },
        --   inline = {
        --     adapter = "anthropic",
        --   },
        -- },
      }
    end,
  },
}
