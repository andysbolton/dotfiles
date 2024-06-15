local M = {}

local config_utils = require "configs.util"
local utils = require "utils"

local formatters_by_filetype = {}
for _, lang in pairs(config_utils.get_configs()) do
  if lang.formatter then
    if utils.empty(lang.ft) or #lang.ft == 0 then
      vim.notify("No filetype set for " .. lang.formatter.name .. ".", vim.log.levels.WARN)
    else
      for _, ft in pairs(lang.ft) do
        formatters_by_filetype[ft] = lang.formatter
      end
    end
  end
end

local function get_file_name(path)
  local matches = {}
  for str in string.gmatch(path, "([^/\\]+)") do
    table.insert(matches, str)
  end
  return matches[#matches]
end

M.register_formatters = function()
  local group = vim.api.nvim_create_augroup("formatting-group", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function(ev)
      local formatter = formatters_by_filetype[vim.bo.filetype]

      if formatter then
        if formatter.use_lsp then
          vim.lsp.buf.format()
        else
          vim.cmd "FormatWrite"
        end

        vim.notify(
          "Formatted "
            .. get_file_name(ev.file)
            .. " with "
            .. (formatter.name or "[couldn't find formatter name]")
            .. (formatter.use_lsp and " (LSP)" or "")
            .. " (buf "
            .. ev.buf
            .. ")."
        )
      end
    end,
  })
end

return M
