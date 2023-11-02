local M = {}

local language_servers = {}
local formatters = {}
local linters = {}
local treesitters = {}

local function get_configs()
  return require "configs"
end

local function get_language_servers()
  if next(language_servers) == nil then
    for _, lang in pairs(get_configs()) do
      if lang.ls then language_servers[lang.ls.name] = lang.ls.settings end
    end
  end

  return language_servers
end

local function get_formatters()
  if next(formatters) == nil then
    for _, lang in pairs(get_configs()) do
      if lang.formatter then
        local formatter = lang.formatter
        formatter.filetypes = lang.ft
        table.insert(formatters, formatter)
      end
    end
  end
  return formatters
end

local function get_linters()
  if next(linters) == nil then
    for _, lang in pairs(get_configs()) do
      if lang.linter then table.insert(linters, lang.linter) end
    end
  end
  return linters
end

local function get_treesitters()
  if next(treesitters) == nil then
    for _, lang in pairs(get_configs()) do
      if lang.treesitter then table.insert(treesitters, lang.treesitter) end
    end
  end
  return treesitters
end

M.get_configs = get_configs
M.get_language_servers = get_language_servers
M.get_formatters = get_formatters
M.get_linters = get_linters
M.get_treesitters = get_treesitters

M.get_config_from_lsp_name = function(lsp_name)
  return get_language_servers()[lsp_name]
end

return M
