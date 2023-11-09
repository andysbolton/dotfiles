return {
  name = "python",
  ft = { "py" },
  ls = {
    name = "pyright",
    settings = {},
  },
  formatter = {
    name = "black",
    actions = {
      function() return require("formatter.filetypes.python").black() end,
    },
  },
  treesitter = "python",
}
