---@class RustAnalyzerCargoSettings
---@field allFeatures boolean
---@field loadOutDirsFromCheck boolean
---@field runBuildScripts boolean

---@class RustAnalyzerCheckOnSaveSettings
---@field allFeatures boolean
---@field command string
---@field extraArgs string[]

---@class RustAnalyzerProcMacroSettings
---@field enable boolean
---@field ignored table<string, string[]>

---@class RustAnalyzerSettings
---@field cargo RustAnalyzerCargoSettings
---@field checkOnSave RustAnalyzerCheckOnSaveSettings
---@field procMacro RustAnalyzerProcMacroSettings

---@class RustaceanvimServerOpts
---@field on_attach fun(client: vim.lsp.Client, bufnr: integer)
---@field settings table<string, RustAnalyzerSettings>

---@class RustaceanvimPluginOpts
---@field server RustaceanvimServerOpts

-- plugins/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    ---@type RustaceanvimPluginOpts
    opts = {
      server = {
        on_attach = function(client, bufnr)
          local key = vim.keymap.set
          key('n', '<leader>ca', function()
            vim.cmd.RustLsp('codeAction')
          end, { desc = 'Code Action', buffer = bufnr })
          key('n', '<leader>dr', function()
            vim.cmd.RustLsp('debuggables')
          end, { desc = 'Rust debuggables', buffer = bufnr })
        end,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = true,
    
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    opts = {},
  }
}
