---@class GoPluginOpts

return {
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ---@type GoPluginOpts
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = '<CMD>GoInstallBinaries<CR>',
  }
}
