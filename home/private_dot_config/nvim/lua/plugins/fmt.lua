local formatters = require("configs.util").get_formatters()

local formatter_names = {}
local filetype_actions = {}
for _, formatter in pairs(formatters) do
  if formatter.name then table.insert(formatter_names, formatter.name) end
  for _, filetype in pairs(formatter.filetypes or {}) do
    filetype_actions[filetype] = formatter.actions
  end
end

return {
  {
    "mhartington/formatter.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = { table.unpack(formatter_names) },
      }

      if not vim.fn.has "win32" then
        -- This formatter is dependent on sed, so disabling for win32.
        filetype_actions["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        }
      end

      require("formatter").setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = filetype_actions,
      }

      require("cmds.fmt").register_formatters()
    end,
  },
}
