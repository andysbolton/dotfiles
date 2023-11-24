local M = {}

local utils = require "utils"
local config_utils = require "configs.util"

local ls_formatters = {}
for _, lang in pairs(config_utils.get_configs()) do
  if lang.formatter then ls_formatters[lang.ls.name] = lang.formatter end
end

--- Register formatters.
-- Registers formatters on LspAttach, which are called on BufWritePost. Will
-- try to attach to the LPS's code formatter, if it exists. If an external
-- formatter is specified in the config, that will be used instead of the LSP
-- formatter.
M.register_formatters = function()
  -- Create an augroup that is used for managing our formatting autocmds.
  -- We need one augroup per client to make sure that multiple clients
  -- can attach to the same buffer without interfering with each other.
  local _augroups = {}
  local get_augroup = function(client)
    if not _augroups[client.id] then
      local group_name = "lsp-format-" .. client.name
      local id = vim.api.nvim_create_augroup(group_name, { clear = true })
      _augroups[client.id] = id
    end

    return _augroups[client.id]
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
    callback = function(args)
      local client_id = args.data.client_id
      local client = vim.lsp.get_client_by_id(client_id)
      local bufnr = args.buf

      local formatter = ls_formatters[client.name]

      if utils.empty(formatter) then
        vim.notify("No conf found for client " .. client.name)
        return
      end

      -- Only attach to clients that support document formatting
      if not client.server_capabilities.documentFormattingProvider and not formatter then
        vim.notify("Client " .. client.name .. " does not support formatting")
        return
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = get_augroup(client),
        buffer = bufnr,
        callback = function()
          -- Prefer an installed formatter over an LSP-formatter if it exists
          if formatter then
            vim.cmd "FormatWrite"
          else
            vim.lsp.buf.format {
              async = false,
              filter = function(c) return c.id == client.id end,
            }
            vim.cmd "write"
          end
          vim.notify("Formatted " .. vim.api.nvim_buf_get_name(bufnr) .. ".")
        end,
      })
    end,
  })
end

return M
