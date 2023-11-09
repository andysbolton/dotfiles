local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = "*",
})

-- disable Copilot in exercism directory
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = vim.fn.expand "~" as string .. "/exercism/*",
  callback = function()
    vim.notify "Copilot disabled in exercism directory"
    vim.cmd "Copilot disable"
  end,
})
