local M = {}

local config_utils = require "configs.util"

local formatters_by_filetype = {}
for _, lang in pairs(config_utils.get_configs()) do
  if lang.formatter and lang.ft then
    for _, ft in pairs(lang.ft) do
      formatters_by_filetype[ft] = lang.formatter
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

--- Register formatters.
-- Registers formatters on LspAttach, which are called on BufWritePost. Will
-- try to attach to the LPS's code formatter, if it exists. If an external
-- formatter is specified in the config, that will be used instead of the LSP
-- formatter.
M.register_formatters = function()
  local group = vim.api.nvim_create_augroup("formatting-group", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function(ev)
      local formatter = formatters_by_filetype[vim.bo.filetype]
      if formatter then
        vim.cmd "FormatWrite"
        vim.notify(
          "Formatted "
            .. get_file_name(ev.file)
            .. " with "
            .. (formatter.name or "[couldn't find formatter name]")
            .. " (buf "
            .. ev.buf
            .. ")."
        )
      end
    end,
  })
end

return M
