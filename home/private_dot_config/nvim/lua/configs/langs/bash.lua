return {
  name = "bash",
  ft = { "sh" },
  ls = {
    name = "bashls",
    settings = {},
  },
  linter = "shellcheck",
  formatter = {
    name = "shfmt",
    actions = {
      function() return require("formatter.filetypes.sh").shfmt end
    }
  },
}
