---@class CoreLspModule
local M = {}

---@class LspServerConfig
---@field capabilities table LSP capabilities
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)
---@field settings? table Server-specific settings
---@field root_markers? string[] Root directory markers
---@field single_file_support? boolean Single file support
---@field cmd? string[] Command to start the LSP server
---@field root_dir? fun(fname: string): string | nil Root directory detection function

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
          diagnostics = { globals = {'vim'} },
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

    rust_analyzer = {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
          inlayHints = {
            chainingHints = { enable = true },
            parameterHints = { enable = true },
            typeHints = { enable = true },
          },
        },
      },
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

    intelephense = {
      capabilities = capabilities,
    },

    jdtls = {
      capabilities = capabilities,
    },

    elixir_ls = {
      capabilities = capabilities,
      -- ElixirLS requires the cmd to be explicitly set.
      -- You need to download and unzip ElixirLS, then provide the absolute path to `language_server.sh` (or `language_server.bat` on Windows).
      -- Example: cmd = { "/path/to/elixir-ls/language_server.sh" },
      cmd = { "YOUR_ABSOLUTE_PATH_TO_ELIXIR_LS/language_server.sh" },
      root_dir = function(fname)
        return vim.fs.find({'mix.exs'}, { upward = true, path = fname }):get(1)
      end,
    },
  }

  -- サーバー設定とアクティベーション
  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end

  -- 共通のキーマップ設定
  M.setup_keymaps()

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
