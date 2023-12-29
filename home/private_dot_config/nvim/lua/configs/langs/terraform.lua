return {
  name = "terraform",
  ft = { "terraform" },
  ls = {
    name = "terraformls",
    settings = {},
  },
  formatter = {
    actions = {
      function() return require("formatter.filetypes.terraform").terraformfmt() end,
    },
  },
  treesitter = "terraform",
}
