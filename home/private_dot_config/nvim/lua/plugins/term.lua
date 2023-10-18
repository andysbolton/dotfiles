local start_insert = function()
  if not vim.g.SessionLoad then vim.cmd "startinsert!" end
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        open_mapping = "<F7>",
        terminal_mappings = false,
        insert_mappings = false,
        on_open = start_insert,
      }

      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w><C-k>]], { silent = true })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w><C-j>]], { silent = true })
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w><C-h>]], { silent = true })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w><C-l>]], { silent = true })

      -- Exit terminal mode with <Esc>
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })

      vim.keymap.set(
        { "n", "t" },
        "<leader>tf",
        "<cmd>ToggleTerm direction=float<CR>",
        { silent = true, desc = "[T]oggle [f]oating terminal" }
      )

      vim.keymap.set(
        { "n", "t" },
        "<leader>tb",
        "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
        { silent = true, desc = "[T]oggle [h]orizontal terminal" }
      )

      vim.keymap.set(
        { "n", "t" },
        "<leader>ts",
        "<cmd>ToggleTerm size=80 direction=vertical<cr>",
        { silent = true, desc = "[T]oggle [v]orizontal terminal" }
      )

      local term_insert_group = vim.api.nvim_create_augroup("TermStartInsert", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = start_insert,
        group = term_insert_group,
        pattern = "term://*",
      })
    end,
  },
}
