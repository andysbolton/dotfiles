vim.fn.setenv("ENV_VAR", "value")


vim.api.nvim_create_autocmd("BufWritePost", {group = group, callback = function()

end })


return {
  name = "jsonc",
  ft = { "jsonc" },
  ls = {
    name = "jsonls",
    settings = {},
  },
  formatter = {
    name = "prettierd",
    actions = {
      function() return require("formatter.filetypes.json").prettierd() end,
    },
  },
  treesitter = "jsonc",
}
