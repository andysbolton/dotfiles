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
      vim.keymap.set("n", "<leader>f", ":Format<cr>", { silent = true, desc = "[F]ormat the current buffer" })
      vim.keymap.set(
        "n",
        "<leader>fw",
        ":FormatWrite<CR>",
        { silent = true, desc = "[F]ormat and [w]rite the current buffer" }
      )

      require("mason-tool-installer").setup {
        ensure_installed = { table.unpack(formatter_names) },
      }

      filetype_actions["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace,
      }

      require("formatter").setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = filetype_actions,
      }

      require("cmds.fmt").register_formatters()
    end,
  },
}
