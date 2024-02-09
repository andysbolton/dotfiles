return {
  name = "clojure",
  ft = { "clojure" },
  ls = {
    name = "clojure_lsp",
    settings = {},
  },
  formatter = {
    name = "zprint",
    actions = {
      function()
        return {
          exe = "zprint",
          args = {},
          stdin = true,
        }
      end,
    },
  },
  treesitter = "clojure",
}
