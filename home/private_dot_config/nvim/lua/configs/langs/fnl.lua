return {
  name = "fennel",
  ft = { "fennel" },
  ls = {
    name = "fennel_language_server",
  },
  formatter = {
    name = "fnlfmt",
    actions = {
      function()
        return {
          exe = "fnlfmt",
          args = { "--fix" },
          stdin = false,
        }
      end,
    },
    autoinstall = false,
  },
  treesitter = "fennel",
}
