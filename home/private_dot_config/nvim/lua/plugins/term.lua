return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        open_mapping = "<leader>t",
        terminal_mappings = false,
        insert_mappings = false,
        on_open = function() vim.cmd "startinsert!" end,
      }

      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w><C-k>]], { silent = true })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w><C-j>]], { silent = true })
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w><C-h>]], { silent = true })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w><C-l>]], { silent = true })
      -- Exit terminal mode with <Esc>
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })
    end,
  },
}
