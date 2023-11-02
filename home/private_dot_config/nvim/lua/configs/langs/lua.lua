return {
  name = "lua",
  ft = { "lua" },
  ls = {
    name = "lua_ls",
    settings = {
      Lua = {
        telemetry = { enable = false },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
    },
  },
  formatter = {
    name = "stylua",
    actions = { function() return require("formatter.filetypes.lua").stylua end },
  },
  treesitter = "lua",
}
