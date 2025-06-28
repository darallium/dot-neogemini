---@class TelescopeLayoutConfigHorizontal
---@field prompt_position string
---@field preview_width number
---@field results_width number

---@class TelescopeLayoutConfigVertical
---@field mirror boolean

---@class TelescopeLayoutConfig
---@field horizontal TelescopeLayoutConfigHorizontal
---@field vertical TelescopeLayoutConfigVertical
---@field width number
---@field height number
---@field preview_cutoff number

---@class TelescopeMappings
---@field n table

---@class TelescopeDefaultsOpts
---@field prompt_prefix string
---@field selection_caret string
---@field path_display string[]
---@field sorting_strategy string
---@field layout_config TelescopeLayoutConfig
---@field mappings TelescopeMappings

---@class TelescopeFindFilesPicker
---@field find_command string[]

---@class TelescopePickers
---@field find_files TelescopeFindFilesPicker

---@class TelescopePluginOpts
---@field defaults TelescopeDefaultsOpts
---@field pickers TelescopePickers

-- plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jump List" },
      { "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter" },
      -- Git関連
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
    },
    ---@type TelescopePluginOpts
    opts = function()
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            n = { ["q"] = "close" },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      }
    end,
  },
}