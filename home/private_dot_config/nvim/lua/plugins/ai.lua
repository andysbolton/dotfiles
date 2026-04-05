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
            accept = "<C-j>",
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
  {
    "zbirenbaum/copilot-cmp",
    config = function() require("copilot_cmp").setup { auto_trigger = false } end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
      },
      "ravitemer/codecompanion-history.nvim",
    },
    config = function()
      require("codecompanion").setup {
        extensions = {
          history = {
            enabled = true,
          },
        },
        interactions = {
          background = {
            adapter = {
              name = "copilot",
            },
          },
          chat = { adapter = "copilot" },
          inline = { adapter = "copilot" },
          cmd = { adapter = "copilot" },
        },
        adapters = {
          acp = {
            copilot_acp = "copilot_acp",
          },
        },
      }
    end,
  },
}
