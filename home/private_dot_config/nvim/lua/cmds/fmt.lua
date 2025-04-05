-- [nfnl] Compiled from fnl/cmds/fmt.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
local config_utils = require("configs.util")
local utils = require("utils")
local formatters_by_ft = {}
for _, lang in pairs(config_utils.get_configs()) do
  if lang.formatter then
    local or_1_ = utils.empty(lang.ft)
    if not or_1_ then
      local function _2_()
        return lang.ft
      end
      or_1_ = (_2_ == 0)
    end
    if or_1_ then
      vim.notify(("No filetypes specified for " .. lang.name .. "."), vim.log.levels.WARN)
    else
      for _0, ft in pairs(lang.ft) do
        formatters_by_ft[ft] = lang.formatter
      end
    end
  else
  end
end
local function get_file_name(path)
  local matches = {}
  for seg in string.gmatch(path, "([^/\\]+)") do
    table.insert(matches, seg)
  end
  return matches[#matches]
end
M.register_formatters = function()
  local group = vim.api.nvim_create_augroup("formatting-group", {clear = true})
  local function _5_(ev)
    local formatter = formatters_by_ft[vim.bo.filetype]
    if formatter then
      if formatter.use_lsp then
        vim.lsp.buf.format()
      else
        vim.cmd("FormatWrite")
      end
      vim.notify(("Formatted " .. get_file_name(ev.file) .. " with " .. (formatter.name or "[couldn't find formatter name]") .. ((formatter.use_lsp and " (LSP)") or "") .. " (buf " .. ev.buf .. ")."))
      return nil
    else
      return nil
    end
  end
  return vim.api.nvim_create_autocmd("BufWritePost", {group = group, callback = _5_})
end
return M
