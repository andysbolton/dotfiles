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
        {
          enabled = true,
          auto_start = true,
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function() require("copilot_cmp").setup() end,
  },
}
