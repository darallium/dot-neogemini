
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = {
      "VeryLazy"
    },
    build = ":TSUpdate",
    dependencies = {
    },
    config = function ()
      local configs = require("nvim-treesitter.configs")

      ---@type TSConfig
      local ts_config = {
        sync_install = false,
        highlight = {
          enable = true,
          disable = {
          }
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        ensure_installed = {
          "css",
          "html",
          "javascript",
          "latex",
          "norg",
          "scss",
          "svelte",
          "tsx",
          "typst",
          "vue",
          "regex",
        }
      }
      configs.setup(ts_config)
    end,
  },
}

