-- lua/plugins/php.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "php" },
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.intelephense.setup({
        -- capabilitiesはcore/lsp.luaで設定されるため、ここでは不要
      })
    end,
  },
}
