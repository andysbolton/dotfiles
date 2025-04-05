return {
  name = "c",
  ft = { "c" },
  ls = {
    name = "clangd",
    settings = {
      cmd = { "clangd", "--clang-tidy", "--offset-encoding=utf-16" },
    },
  },
  formatter = {
    name = "clang-format",
    actions = {
      function() return require("formatter.filetypes.c").clangformat() end,
    },
  },
  linter = { name = "cpplint" },
  treesitter = "c",
}
