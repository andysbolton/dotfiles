-- [nfnl] fnl/configs/langs/c.fnl
local function _1_()
  local fmt = require("formatter.filetypes.c")
  return fmt.clangformat()
end
return {name = "c", ft = {"c"}, ls = {name = "clangd", settings = {cmd = {"clangd", "--clang-tidy", "--offset-encoding=utf-16"}}}, formatter = {name = "clang-format", actions = _1_}, linter = {name = "cpplint"}, treesitter = "c"}
