-- plugins/dashboard.lua
return {
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    lazy = false,
    priority = 1000,
    opts = function()
      local logo = [[
           ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
           ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
           ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
           ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
           ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
           ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      return {
        dashboard = {
          enabled = true,
          header = vim.split(logo, "\n"),
          items = {
            { desc = " Find file", key = "f", cmd = "Telescope find_files" },
            { desc = " New file", key = "n", cmd = "ene | startinsert" },
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
      }
    end,
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
    end,
  },
}