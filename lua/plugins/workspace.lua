-- Workspace management using project.nvim
return {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {
      -- detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
    },
    config = function(_, opts)
      ---@type ProjectNvimOptions
      local project_opts = opts
      require("project_nvim").setup(project_opts)
    end,
  },
}
