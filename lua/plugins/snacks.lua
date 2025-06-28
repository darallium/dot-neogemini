---@class SnacksDashboardItem
---@field desc string
---@field key string
---@field cmd string

---@class SnacksDashboardOpts
---@field enabled boolean
---@field header string[]
---@field items SnacksDashboardItem[]
---@field footer fun(): string[]

---@class SnacksNotifierOpts
---@field enabled boolean

---@class SnacksPluginOpts
---@field dashboard SnacksDashboardOpts
---@field notifier SnacksNotifierOpts

-- plugins/snacks.lua
return {
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    lazy = false,
    priority = 1000,
    ---@type SnacksPluginOpts
    opts = {
      dashboard = {
        enabled = true,
        header = vim.split(string.rep("\n", 8) .. [[
           ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
           ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
           ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
           ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
           ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
           ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚══╝  ╚═╝╚═╝     ╚═╝
]] .. "\n\n", "\n"),
        items = {
          { desc = " Find file", key = "f", cmd = "Telescope find_files" },
          { desc = " New file", key = "n", cmd = "enew" },
          { desc = " Recent files", key = "r", cmd = "Telescope oldfiles" },
          { desc = " Find text", key = "g", cmd = "Telescope live_grep" },
          { desc = " Restore Session", key = "s", cmd = 'lua require("persistence").load()' },
          { desc = " Lazy Extras", key = "x", cmd = "LazyExtras" },
          { desc = " Lazy", key = "l", cmd = "Lazy" },
          { desc = " Quit", key = "q", cmd = "qa" },
        },
        footer = function()
          local stats = require("lazy").stats()
          if not stats then return {} end
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
      notifier = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksDashboardOpened",
          callback = function()
            require("lazy").show()
          end,
          once = true,
        })
      end
    },
  },
}
