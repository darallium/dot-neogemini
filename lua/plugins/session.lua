-- Session management
return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("data") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    config = function(_, opts)
      ---@type PersistenceOptions
      local persistence_opts = opts
      require("persistence").setup(persistence_opts)
      -- Keymaps for session management
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save current session" })
    end,
  },
}
