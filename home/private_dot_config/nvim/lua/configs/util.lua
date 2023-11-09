local utils = require "utils"

local M = {}

local language_servers = {}
local formatters = {}
local ls_formatters = {}
local linters = {}
local treesitters = {}

local function get_configs() return require "configs" end

local function get_language_servers()
  if utils.empty(language_servers) then
    for _, lang in pairs(get_configs()) do
      if lang.ls then language_servers[lang.ls.name] = lang.ls.settings end
    end
  end

  return language_servers
end

local function get_formatters()
  if utils.empty(formatters) then
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
  if utils.empty(linters) then
    for _, lang in pairs(get_configs()) do
      if lang.linter then
        local linter = lang.linter
        linter.filetypes = lang.ft
        table.insert(linters, lang.linter)
      end
    end
  end
  return linters
end

local function get_treesitters()
  if utils.empty(treesitters) then
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

return M
