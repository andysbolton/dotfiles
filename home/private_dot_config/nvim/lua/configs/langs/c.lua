return {
  name = "c",
  ft = { "c" },
  ls = {
    name = "clangd",
    settings = {
      cmd = { "clangd", "--clang-tidy", "--offset-encoding=utf-16" },
    },
  },
  linter = { name = "cpplint" },
  treesitter = "c",
}
