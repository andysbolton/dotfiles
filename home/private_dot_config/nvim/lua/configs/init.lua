local files = vim.api.nvim_get_runtime_file("lua/configs/langs/*.lua", true)

local langs = {}
for _, filename in pairs(files) do
  local module = "configs.langs." .. string.gsub(filename, "(.*[/\\])(.*)%.lua", "%2")
  local lang = require(module)
  if type(lang) == "table" then
    table.insert(langs, lang)
  end
end

return langs
