-- [nfnl] fnl/plugins/qf.fnl
local function _1_()
  local _let_2_ = require("quicker")
  local collapse = _let_2_.collapse
  local expand = _let_2_.expand
  local toggle = _let_2_.toggle
  local qfsetup = _let_2_.setup
  local function _3_()
    return toggle()
  end
  vim.keymap.set("n", "<leader>q", _3_, {desc = "Toggle quickfix"})
  local function _4_()
    return toggle({loclist = true})
  end
  vim.keymap.set("n", "<leader>l", _4_, {desc = "Toggle loclist"})
  local function _5_()
    return expand({before = 2, after = 2, add_to_existing = true})
  end
  local function _6_()
    return collapse()
  end
  return qfsetup({keys = {{">", _5_, desc = "Expand quickfix context"}, {"<", _6_, desc = "Collapse quickfix context"}}})
end
return {"stevearc/quicker.nvim", config = _1_}
