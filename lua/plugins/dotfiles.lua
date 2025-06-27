-- Dotfiles management for cloud-native development
return {
  {
    "kazhala/dotfiles.nvim",
    cmd = "Dotfiles",
    opts = {
      -- path to your dotfiles repository
      path = "~/dotfiles",
      -- mapping to open a file in your dotfiles
      mappings = true,
    },
    config = function(_, opts)
      ---@type DotfilesOptions
      local dotfiles_opts = opts
      require("dotfiles").setup(dotfiles_opts)
    end,
  },
}
