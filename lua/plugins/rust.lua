-- plugins/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
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
          default_settings = {
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
      }
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      vim.keymap.set("n", "<leader>cs", function() require('crates').show() end, { desc = "Show Crates" })
    end,
  },
}
