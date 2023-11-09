local M = {}

local function empty(table)
    return table == nil or next(table) == nil
end

M.empty = empty

return M
