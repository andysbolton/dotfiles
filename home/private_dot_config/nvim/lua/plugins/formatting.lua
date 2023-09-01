return {
  {
    'mhartington/formatter.nvim',
    config = function()
      require "formatter".setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua
          },
          python = {
            require("formatter.filetypes.python").black
          },
          ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace
          }
        }
      }
    end
  }
}
