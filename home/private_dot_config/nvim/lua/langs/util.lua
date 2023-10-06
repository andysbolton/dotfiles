local M = {}

local servers = require "langs.conf"

M.get_lsp_conf_for_lang = function(lang)
  local server = servers[lang]
  if server then
    for k, v in pairs(server) do
      if k ~= "formatter" and k ~= "linter" then return k, v end
    end
  end
  return nil
end

M.get_formatter_for_lang = function(lang)
  local server = servers[lang]
  if server and server.formatter then return server.formatter end
  return nil
end

M.get_lsp_conf_table = function()
  local lsp_confs = {}
  for lang, _ in pairs(servers) do
    local server, config = M.get_lsp_conf_for_lang(lang)
    if server then lsp_confs[server] = config end
  end
  return lsp_confs
end

M.get_conf_from_lsp_name = function(lsp_name)
  for lang, conf in pairs(servers) do
    if servers[lang][lsp_name] then return conf end
  end
end

M.get_formatters = function()
  local formatters = {}
  for lang, _ in pairs(servers) do
    local formatter = M.get_formatter_for_lang(lang)
    if formatter then table.insert(formatters, formatter) end
  end
  return formatters
end

return M
