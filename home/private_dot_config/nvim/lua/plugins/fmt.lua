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

      local formatters = require("configs.util").get_formatters()

      local formatter_names = {}
      local filetype_actions = {}
      for _, formatter in pairs(formatters) do
        if formatter.name then table.insert(formatter_names, formatter.name) end
        for _, filetype in pairs(formatter.filetypes or {}) do
          filetype_actions[filetype] = formatter.actions
        end
      end

      require("mason-tool-installer").setup {
        ensure_installed = { table.unpack(formatter_names) },
      }

      local default_formatters = {
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      }

      require("formatter").setup {
        -- Enable or disable logging
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          table.unpack(default_formatters),
          table.unpack(filetype_actions),
        },
      }

      require("cmds.fmt").register_formatters()
    end,
  },
}
