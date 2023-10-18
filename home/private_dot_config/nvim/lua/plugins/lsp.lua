return {
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   config = function()
  --     require("lspsaga").setup {
  --       lightbulb = {
  --         virtual_text = false,
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  -- },

  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        config = true,
      },

      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          -- LSP settings.
          -- This function gets run when an LSP connects to a particular buffer.
          local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
              if desc then desc = "LSP: " .. desc end

              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            -- nmap("<leader>ca", function() vim.cmd [[ Lspsaga code_action ]] end, "[C]ode [A]ction")

            nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
            nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
            nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

            nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

            -- Lesser used LSP functionality
            nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            -- nmap(
            --   "<leader>wl",
            --   function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            --   "[W]orkspace [L]ist Folders"
            -- )
            --
            --
            local lsp_util = vim.lsp.util
            local code_action_group = vim.api.nvim_create_augroup("CodeAction", { clear = true })
            local count = 0
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              callback = function()
                local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
                local params = lsp_util.make_range_params()
                params.context = context
                -- vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, result, ctx, config)
                --   -- do something with result - e.g. check if empty and show some indication such as a sign
                --   -- if count == 0 then
                --   --   vim.notify(require("utils.debug").dump(result[1]))
                --   --   count = count + 1
                --   -- end
                -- end)
              end,
              group = code_action_group,
              pattern = "*",
            })
          end

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

          -- Ensure the servers above are installed
          local mason_lspconfig = require "mason-lspconfig"

          local lsp_config = require("langs.util").get_lsp_conf_table()

          mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(lsp_config),
          }

          mason_lspconfig.setup_handlers {
            function(server_name)
              require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = lsp_config[server_name],
              }
            end,
          }

          require("lspkind").init {
            mode = "symbol_text",
            preset = "codicons",
            symbol_map = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "",
            },
          }
        end,
      },

      -- Useful status updates for LSP
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        config = true,
      },

      {
        "folke/neodev.nvim",
        config = true,
      },

      "onsails/lspkind.nvim",
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    config = true,
  },
}
