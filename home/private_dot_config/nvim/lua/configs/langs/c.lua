return {
  name = "c",
  ls = {
    name = "clangd",
    settings = {
      cmd = { "clangd", "--clang-tidy", "--offset-encoding=utf-16" },
    },
  },
  linter = "cpplint",
  treesitter = "c",
}
