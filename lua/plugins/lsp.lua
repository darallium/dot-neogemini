-- plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Prevent nvim-lspconfig from setting up rust_analyzer, as rustaceanvim handles it.
      require("lspconfig").configs.rust_analyzer = nil
      
      require("lspconfig").configs.jsonls = nil

      -- Neovim 0.11+の場合は新API使用
      if vim.fn.has('nvim-0.11') == 1 then
        require("core.lsp").setup(capabilities)
        return
      end
      
      -- レガシーAPI設定
      --require("plugins.lsp.legacy").setup(capabilities)
    end
  }
}
