-- plugins/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
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
        settings = {
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
    },
    config = true,
    
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    opts = {},
  }
}
