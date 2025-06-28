---@class CoreLspModule
local M = {}

---@class LspServerConfig
---@field capabilities table LSP capabilities
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)
---@field settings? table Server-specific settings
---@field root_markers? string[] Root directory markers
---@field single_file_support? boolean Single file support

---@param capabilities table LSP capabilities
function M.setup(capabilities)
  if vim.fn.has('nvim-0.11') == 0 then return end
  
  capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()
  
  ---@type table<string, LspServerConfig>
  local servers = {
    lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          hint = { enable = true, paramName = 'All', paramType = true },
          completion = { callSnippet = 'Replace' },
          diagnostics = {
            globals = { 'vim', 'use', 'describe', 'it', 'before_each', 'after_each' }
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      },
    },
    
    
    
    ts_ls = {
      capabilities = capabilities,
      single_file_support = false,
      root_markers = { "tsconfig.json", "package.json" },
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayVariableTypeHints = true,
          },
        },
      },
      on_attach = function(client, bufnr)
        -- Node.js プロジェクト検出
        local is_node_project = vim.fs.find('package.json', {
          upward = true,
          path = vim.api.nvim_buf_get_name(bufnr)
        })[1] ~= nil
        
        if not is_node_project then
          client.stop(true)
          return
        end
      end,
    },
    
    pyright = {
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      },
    },
    
    clangd = {
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
      },
    },
    
    gopls = {
      capabilities = capabilities,
      settings = {
        gopls = {
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    },

    jdtls = {
      capabilities = capabilities,
    },

    intelephense = {
      capabilities = capabilities,
    },
  }
  
  -- サーバー設定とアクティベーション
  local on_attach = function(client, bufnr)
    require("nvim-navic").attach(client, bufnr)
    -- 共通のキーマップ設定
    M.setup_keymaps()
  end

  for name, config in pairs(servers) do
    -- Skip rust_analyzer as it's handled by rustaceanvim
    if name == "rust_analyzer" then
      goto continue
    end

    local original_on_attach = config.on_attach
    config.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      if original_on_attach then
        original_on_attach(client, bufnr)
      end
    end
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
    ::continue::
  end
  
  
  
  -- 診断設定
  M.setup_diagnostics()
end

---@private
function M.setup_keymaps()
  local key = vim.keymap.set
  
  key('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
  key('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
  key('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
  key('n', 'gr', vim.lsp.buf.references, { desc = 'Show references' })
  key('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover' })
  key('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
  key('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
  key('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })
end

---@private
function M.setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      source = 'if_many',
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })
end

return M