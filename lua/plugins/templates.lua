-- Project templates using prodir.nvim
return {
  {
    "glepnir/prodir.nvim",
    cmd = "Prodir",
    opts = {
      -- Your template directory
      template_dir = vim.fn.stdpath("config") .. "/templates/",
    },
    config = function(_, opts)
      ---@type ProdirOptions
      local prodir_opts = opts
      require("prodir").setup(prodir_opts)
      -- Keymap to create a new project
      vim.keymap.set("n", "<leader>pn", "<cmd>Prodir<cr>", { desc = "New project from template" })
    end,
  },
}
