-- Testing integration using neotest
return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      
    },
    config = function(_, opts)
      ---@type NeotestOptions
      local neotest_opts = {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          
        },
      }
      local neotest = require("neotest")

      neotest.setup(neotest_opts)

      -- Keymaps
      vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tT", function() neotest.run.run(vim.fn.expand("%:p")) end, { desc = "Run all tests in file" })
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
      vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Show test output" })
    end,
  },
}
