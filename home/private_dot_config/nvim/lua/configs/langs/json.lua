return {
  name = "json",
  ft = { "json" },
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
  treesitter = "json",
}
