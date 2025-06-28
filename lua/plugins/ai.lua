---@class AvanteBehaviourOpts
---@field auto_suggestions boolean
---@field auto_set_highlight_group boolean
---@field auto_set_keymaps boolean
---@field auto_apply_diff_after_generation boolean
---@field support_paste_from_clipboard boolean
---@field minimize_diff boolean

---@class AvanteWindowsOpts
---@field position string
---@field wrap boolean
---@field width integer

---@class AvantePluginOpts
---@field provider string
---@field auto_suggestions_provider string
---@field behaviour AvanteBehaviourOpts
---@field windows AvanteWindowsOpts

-- AI-assisted development plugins
return {
  -- Tabby
  {
    "TabbyML/vim-tabby",
    event = "InsertEnter",
    config = function()
      vim.g.tabby_keybinding_accept = "<Tab>"
    end,
  },
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          dismiss = "<C-h>",
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = {
        enabled = true,
      },
      filetypes = {
        markdown = false,
        yaml = false,
        json = false,
        ["."] = false,
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    ---@type AvantePluginOpts
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      
      -- 動作設定
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
      },

      -- ウィンドウ設定
      windows = {
        position = "right",  -- サイドバーの位置
        wrap = true,        -- テキストの折り返し
        width = 30,         -- サイドバーの幅
        -- その他の詳細設定は省略
      },
    },
    -- 依存関係の設定
    dependencies = {
      -- 必須の依存関係
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- オプションの依存関係
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      -- その他の拡張機能
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    }
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "stevearc/dressing.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    ---@class CodeCompanionGeminiAdapterOpts
    ---@field adapter table
    ---@field api_key string

    ---@class CodeCompanionAdaptersOpts
    ---@field gemini CodeCompanionGeminiAdapterOpts

    ---@class CodeCompanionPluginOpts
    ---@field adapters CodeCompanionAdaptersOpts
    ---@type CodeCompanionPluginOpts
    opts = {
      adapters = {
        gemini = {
          -- adapter = require("codecompanion.adapters.gemini"),
          -- api_key = os.getenv("GEMINI_API_KEY"),
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}