return {
  name = "go",
  ls = {
    name = "gopls",
    settings = {
      settings = {
        gopls = {
          gofumpt = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  treesitter = "go",
}
