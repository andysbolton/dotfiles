local M = {}

local function empty(tabl)
    return next(tabl) == nil
end

M.empty = empty

return M
