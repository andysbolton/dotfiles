return {
  name = "json",
  ft = { "json" },
  ls = {
    name = "jsonls",
    settings = {},
  },
  formatter = {
    name = "prettierd",
    actions = {
      function()
        local util =  require "formatter.util"
        return {
          -- exe = string.format(
          --   "PRETTIERD_DEFAULT_CONFIG=%s %s",
          --   vim.fn.expand "~/.config/nvim/lua/configs/linter/.prettierrc.json",
          --   "prettierd"
          -- ),
          exe = "prettierd",
          args = { util.escape_path(util.get_current_buffer_file_path()) },
          stdin = true,
        }
      end,
    },
  },
  treesitter = "json",
}
