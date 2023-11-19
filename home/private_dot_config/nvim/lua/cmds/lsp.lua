local M = {}

local util = require("utils")

vim.fn.sign_define("LightBulbSign", { text = "💡", texthl = "LspDiagnosticsDefaultInformation" })

M.setup_codeactions = function(bufnr)
  local ns_id = vim.api.nvim_create_namespace("code-actions-virtual-text" .. bufnr)
  local lsp_util = vim.lsp.util
  local code_action_group = vim.api.nvim_create_augroup("code-action-" .. bufnr, { clear = true })

  local line = 0
  local mark_id = 0
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
      local params = lsp_util.make_range_params()
      params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

      vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(result)
        if line ~= 0 then vim.fn.sign_unplace("LightBulbSign", { lnum = line, buffer = bufnr }) end
        if mark_id ~= 0 then vim.api.nvim_buf_del_extmark(bufnr, ns_id, mark_id) end
        line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))

        if result and result[1] and not util.empty(result[1]) and not util.empty(result[1].result) then
          local line_num = line - 1
          local col_num = 0

          local text = " " .. #result[1].result .. " code " .. (#result[1].result > 1 and "actions" or "action")

          local opts = {
            virt_text = { { text, "DiagnosticInfo" } },
            virt_text_pos = "right_align",
          }

          mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, line_num, col_num, opts)
          vim.fn.sign_place(0, "LightBulbSign", "LightBulbSign", bufnr, { lnum = line, priority = 10 })
        end
      end)
    end,
    group = code_action_group,
    buffer = bufnr,
  })
end

return M
