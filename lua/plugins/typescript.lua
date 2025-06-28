---@class TsserverFilePreferences
---@field includeInlayParameterNameHints string
---@field includeInlayVariableTypeHints boolean
---@field includeInlayFunctionLikeReturnTypeHints boolean

---@class TsserverFormatOptions
---@field allowIncompleteCompletions boolean
---@field allowRenameOfImportPath boolean

---@class TypescriptToolsSettings
---@field tsserver_file_preferences TsserverFilePreferences
---@field tsserver_format_options TsserverFormatOptions

---@class TypescriptToolsPluginOpts
---@field settings TypescriptToolsSettings

-- plugins/typescript.lua
return {
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim" },
    ---@type TypescriptToolsPluginOpts
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    },
  },
}