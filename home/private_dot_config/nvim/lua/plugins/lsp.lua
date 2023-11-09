return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",

      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          local on_attach = function(client, bufnr)
            local nmap = function(keys, func, desc)
              if desc then desc = "LSP: " .. desc end

              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

            nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            nmap("gD", vim.lsp.buf.definition, "[G]oto [D]eclaration")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

            nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
            nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

            nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

            nmap("<leader>wra", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            nmap("<leader>wrr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            nmap(
              "<leader>wrl",
              function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
              "[W]orkspace [L]ist Folders"
            )

            if client.supports_method "textDocument/codeAction" then
              nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
              require("cmds.lsp").setup_codeactions(bufnr)
            end
          end

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

          local mason_lspconfig = require "mason-lspconfig"

          local language_servers = require("configs.util").get_language_servers()

          local efm = {
            languages = {
              teal = {
                {
                  lintStdin = true,
                  lintIgnoreExitCode = true,
                  -- the sed command will transform the output from:
                  --   2 warnings:
                  --   teal/init.tl:1:1: unused function add: function(number): number
                  --   teal/init.tl:2:1: unused function add2: function(number): number
                  --   ========================================
                  --   3 errors:
                  --   teal/init.tl:4:1: unknown variable: vim
                  --   teal/init.tl:5:1: unknown variable: vim
                  --   teal/init.tl:7:1: unknown variable: vim
                  -- to:
                  --   2 warnings:
                  --   w: teal/init.tl:1:1: unused function add: function(number): number
                  --   w: teal/init.tl:2:1: unused function add2: function(number): number
                  --   ========================================
                  --   13 errors:
                  --   e: teal/init.tl:4:1: unknown variable: vim
                  --   e: teal/init.tl:5:1: unknown variable: vim
                  --   e: teal/init.tl:7:1: unknown variable: vim
                  lintCommand = "tl check ${INPUT} 2>&1 | sed -r '/warning/,/=/ { /warning/b; /=/b; s/^/w: / }; /error/,/$p/ { /error/b; /$p/b; s/^/e: / }'",
                  lintFormats = {
                    "%t: %f:%l:%c: %m",
                  },
                },
              },
            },
          }

          mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(language_servers),
          }

          mason_lspconfig.setup_handlers {
            function(server_name)
              require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = language_servers[server_name],
              }
            end,
          }

          require("lspconfig").efm.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = efm,
            filetypes = { "teal" },
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
