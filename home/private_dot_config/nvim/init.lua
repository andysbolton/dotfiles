vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sensible',

  'github/copilot.vim',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- {
  --   "iamcco/markdown-preview.nvim",
  --   config = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  -- },

  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    opts = {
      width_ratio = 1,
      height_ratio = 1
    }
  },

  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        -- auto_session_create_enabled = false,
        pre_save_cmds = {
          function()
            vim.notify('closing neotree')
            require 'neo-tree.sources.manager'.close_all()
          end
        },
        pre_restore_cmds = {
          function()
            vim.notify('closing neotree')
            require 'neo-tree.sources.manager'.close_all()
          end
        },
        post_restore_cmds = {
          function()
            vim.notify('opening neotree')
            require 'neo-tree.sources.manager'.show('filesystem')
          end
        },
      }
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end
  },

  {
    'alker0/chezmoi.vim',
    lazy = false,
    init = function()
      vim.g['chezmoi#use_tmp_buffer'] = true
    end,
  },

  {
    'folke/which-key.nvim',
    config = true
  },

  {
    'mg979/vim-visual-multi',
    branch = 'master'
  },

  'romainl/vim-cool',

  {
    'numToStr/Comment.nvim',
    config = true
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {},
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    import = 'plugins'
  },

  {
    import = 'plugins.custom'
  },
}, {})

require 'mappings'
require 'options'

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<leader>ca', function()
    vim.cmd [[ Lspsaga code_action ]]
  end, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local servers = {
  clangd = {
    cmd = { 'clangd', '--clang-tidy', '--offset-encoding=utf-8' }
  },
  csharp_ls = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        }
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
  azure_pipelines_ls = {},
  powershell_es = {},
  -- asm_lsp = {},
  terraformls = {},
  pyright = {},
  -- dockerls = {},
  bashls = {},

  lua_ls = {
    Lua = {
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- vim: ts=2 sts=2 sw=2 et
