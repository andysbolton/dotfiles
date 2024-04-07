local md_namespace = vim.api.nvim_create_namespace "lsp_float"

--- LSP handler that adds extra inline highlights, keymaps, and window options.
--- Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param title string
---@return fun(err: any, result: any, ctx: any, config: any)
local function enhanced_float_handler(handler, title)
  return function(err, result, ctx, config)
    local bufnr, winnr = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend("force", config or {}, {
        border = "double",
        title = title,
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      })
    )

    if not bufnr or not winnr then return end

    -- Conceal everything.
    vim.wo[winnr].concealcursor = "n"

    -- Extra highlights.
    for l, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
      for pattern, hl_group in pairs {
        ["|%S-|"] = "@text.reference",
        ["@%S+"] = "@parameter",
        ["^%s*(Parameters:)"] = "@text.title",
        ["^%s*(Return:)"] = "@text.title",
        ["^%s*(See also:)"] = "@text.title",
        ["{%S-}"] = "@parameter",
      } do
        local from = 1 ---@type integer?
        while from do
          local to
          from, to = line:find(pattern, from)
          if from then
            vim.api.nvim_buf_set_extmark(bufnr, md_namespace, l - 1, from - 1, {
              end_col = to,
              hl_group = hl_group,
            })
          end
          from = to and to + 1 or nil
        end
      end
    end

    -- Add keymaps for opening links.
    if not vim.b[bufnr].markdown_keys then
      vim.keymap.set("n", "K", function()
        -- Vim help links.
        local url = (vim.fn.expand "<cWORD>" --[[@as string]]):match "|(%S-)|"
        if url then return vim.cmd.help(url) end

        -- Markdown links.
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = vim.api.nvim_get_current_line():find "%[.-%]%((%S-)%)"
        if from and col >= from and col <= to then
          -- TODO: This isn't working if there are pound signs in the URL as they get expanded.
          vim.cmd("silent !open " .. url)
        end
      end, { buffer = bufnr, silent = true })
      vim.b[bufnr].markdown_keys = true
    end
  end
end

vim.lsp.handlers["textDocument/hover"] = enhanced_float_handler(vim.lsp.handlers.hover, "textDocument/hover")
vim.lsp.handlers["textDocument/signatureHelp"] =
  enhanced_float_handler(vim.lsp.handlers.signature_help, "textDocument/signatureHelp")

return {
  {
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

            nmap("<leader>wra", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            nmap("<leader>wrr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            nmap("<leader>wrl", vim.lsp.buf.list_workspace_folders, "[W]orkspace [L]ist Folders")

            if client.supports_method "textDocument/codeAction" then
              vim.keymap.set({ "n", "v" }, "<leader>ca", function()
                if vim.fn.has "win32" == 1 then
                  vim.lsp.buf.code_action()
                else
                  -- This has a dependency on mkfifo at the moment,
                  -- so it can't be used on Windows.
                  require("fzf-lua").lsp_code_actions {
                    winopts = {
                      relative = "cursor",
                      width = 0.6,
                      height = 0.6,
                      row = 1,
                      preview = { vertical = "up:70%" },
                    },
                  }
                end
              end, { buffer = bufnr, desc = "[C]ode [A]ction" })

              require("cmds.lsp").setup_codeactions(bufnr)
            end

            if client.supports_method "textDocument/formatting" then
              nmap("<leader>cf", vim.lsp.buf.format, "[C]ode [f]ormat")
            end

            if client.supports_method "textDocument/signatureHelp" then
              nmap("<C-s>", vim.lsp.buf.signature_help, "Signature Help")
            end
          end

          local signs = {
            ERROR = " ",
            WARN = " ",
            HINT = " ",
            INFO = " ",
          }

          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type:sub(1, 1) .. type:sub(2):lower()
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end

          vim.diagnostic.config {
            virtual_text = {
              prefix = "",
              format = function(diagnostic)
                return signs[vim.diagnostic.severity[diagnostic.severity]:upper()] .. diagnostic.message
              end,
            },
            float = {
              border = "rounded",
              source = "if_many",
              -- Show severity icons as prefixes.
              prefix = function(diag)
                local level = vim.diagnostic.severity[diag.severity]:upper()
                local prefix = string.format(" %s ", signs[level])
                return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
              end,
            },
          }

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

          local mason_lspconfig = require "mason-lspconfig"
          local language_servers = require("configs.util").get_language_servers()

          local language_servers_to_install = vim.tbl_keys(language_servers)
          -- table.insert(language_servers_to_install, "efm")
          mason_lspconfig.setup {
            ensure_installed = language_servers_to_install,
          }

          mason_lspconfig.setup_handlers {
            function(server_name)
              if server_name ~= "efm" then
                require("lspconfig")[server_name].setup {
                  capabilities = capabilities,
                  on_attach = on_attach,
                  settings = language_servers[server_name],
                }
              else
                require("lspconfig").efm.setup {
                  capabilities = capabilities,
                  on_attach = on_attach,
                  filetypes = { "teal" },
                  root_dir = require("lspconfig.util").root_pattern "tlconfig.lua",
                  settings = {
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
                          -- lintCommand = "tl check ${INPUT} 2>&1 | sed -r '/warning/,/=/ { /warning/b; /=/b; s/^/w: / }; /error/,/$p/ { /error/b; /$p/b; s/^/e: / }'",
                          lintCommand = [[tl check ${INPUT} 2>&1 | sed -r '/warning/,/=/ { s|^|w: | }; /error/,/$p/ { s|^|e: | }']],
                          lintFormats = {
                            "%t: %f:%l:%c: %m",
                          },
                        },
                      },
                    },
                  },
                }
              end
            end,
          }

          if vim.fn.has "win32" == 1 then
            local ahk2_config = {
              autostart = true,
              cmd = {
                "node",
                vim.fn.expand "$HOME/vscode-autohotkey2-lsp/server/dist/server.js",
                "--stdio",
              },
              filetypes = { "ahk", "autohotkey", "ah2" },
              init_options = {
                locale = "en-us",
                InterpreterPath = vim.fn.expand "$HOME/scoop/shims/autohotkey.exe",
              },
              single_file_support = true,
              flags = { debounce_text_changes = 500 },
              capabilities = capabilities,
              on_attach = on_attach,
            }
            local configs = require "lspconfig.configs"
            configs["ahk2"] = { default_config = ahk2_config }
            require("lspconfig").ahk2.setup {}
          end

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

  -- {
  --   "ray-x/lsp_signature.nvim",
  --   config = true,
  -- },
}
