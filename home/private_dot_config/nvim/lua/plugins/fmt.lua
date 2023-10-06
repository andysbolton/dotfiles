return {
  {
    "mhartington/formatter.nvim",
    -- keys =
    config = function()
      vim.keymap.set("n", "<leader>f", ":Format<cr>", { silent = true, desc = "[F]ormat the current buffer" })
      vim.keymap.set(
        "n",
        "<leader>fw",
        ":FormatWrite<CR>",
        { silent = true, desc = "[F]ormat and [w]rite the current buffer" }
      )

      require("formatter").setup {
        -- Enable or disable logging
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
          python = {
            require("formatter.filetypes.python").black,
          },
          yaml = {
            require("formatter.filetypes.yaml").prettierd,
          },
          terraform = {
            require("formatter.filetypes.terraform").terraformfmt,
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
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

      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
        -- This is where we attach the autoformatting for reasonable clients
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          local conf = require("langs.util").get_conf_from_lsp_name(client.name)

          if not conf then
            vim.notify("No conf found for client " .. client.name)
            return
          end

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider and not conf.formatter then
            vim.notify("Client " .. client.name .. " does not support formatting")
            return
          end

          --Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              -- Prefer an installed formatter over an LSP-formatter if it exists
              if conf.formatter then
                vim.cmd [[FormatWrite]]
              else
                vim.lsp.buf.format {
                  async = false,
                  filter = function(c) return c.id == client.id end,
                }
                vim.cmd [[write]]
              end
            end,
          })
        end,
      })
    end,
  },
}
