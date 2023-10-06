--  returns a table where the key is the language name and the value is a `lang` table.
--  a `lang` table has the following key/values:
--    - `{lsp_server_name}` (string): configuration for the language server (table)
--    - `formatter` (string?): name of the formatter (for use with formatter.nvim), will override the LSP's formatter if it exists
--    - `linter` (string?): name of the linter

return {
  c = {
    clangd = {
      cmd = { "clangd", "--clang-tidy", "--offset-encoding=utf-16" },
    },
  },
  csharp = { csharp_ls = {} },
  go = {
    gopls = {
      settings = {
        gopls = {
          gofumpt = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  -- azure_pipelines = {
  --   azure_pipelines_ls = {
  --     settings = {
  --       yaml = {
  --         schemas = {
  --           ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
  --             ".ci/**/*.yml",
  --             "azure-pipelines.yml",
  --           },
  --         },
  --       },
  --     },
  --   },
  --   formatter = "prettierd",
  -- },
  yaml = {
    yamlls = {
      settings = {
        yaml = {
          schemas = {
            -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
            --   "docker-compose*.yml",
            --   "docker-compose.*.yml",
            -- },
            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
              ".ci/*.yml",
              "azure-pipelines.yml",
            },
          },
        },
      },
    },
    formatter = "prettierd",
  },
  powershell = { powershell_es = {} },
  asm = { asm_lsp = {} },
  terraform = { terraformls = {}, formatter = "terraformfmt" },
  python = { pyright = {}, formatter = "black" },
  docker = { dockerls = {} },
  bash = { bashls = {} },
  lua = {
    lua_ls = {
      Lua = {
        telemetry = { enable = false },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
    },
    formatter = "stylua",
  },
}
