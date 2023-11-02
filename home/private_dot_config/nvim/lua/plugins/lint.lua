return {
  "mfussenegger/nvim-lint",
  dependencies = { "williamboman/mason.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
  config = function()
    require("lint").linters_by_ft = {
      c = { "cpplint" },
      sh = { "shellcheck" },
    }

    local linters = require("configs.util").get_linters()

    require("mason-tool-installer").setup {
      ensure_installed = { table.unpack(linters) },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function() require("lint").try_lint() end,
    })
  end,
}
