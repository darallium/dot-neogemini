
---@class NeoTreeFilteredItems
---@field visible boolean
---@field hide_dotfiles boolean
---@field hide_git_ignored boolean
---@field hide_hidden boolean

---@class NeoTreeFollowCurrentFile
---@field enabled boolean
---@field leave_open boolean

---@class NeoTreeFilesystem
---@field filtered_items NeoTreeFilteredItems
---@field follow_current_file NeoTreeFollowCurrentFile

---@class NeoTreeMappingOptions
---@field noremap boolean
---@field nowait boolean

---@class NeoTreeWindow
---@field width integer
---@field position string
---@field mapping_options NeoTreeMappingOptions

---@class NeoTreePluginOpts
---@field close_if_last_window boolean
---@field filesystem NeoTreeFilesystem
---@field window NeoTreeWindow

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but good for file icons
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    ---@type NeoTreePluginOpts
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_git_ignored = true,
          hide_hidden = true,
        },
        follow_current_file = {
          enabled = true,
          leave_open = true,
        },
      },
      window = {
        width = 30,
        position = "left",
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua", -- For compatibility with older configurations or if Neo-tree is not preferred
    lazy = true,
    cmd = "NvimTreeToggle",
  },
  {
    "startup-nvim/startup.nvim",
    event = "VimEnter",
    opts = function()
      local function open_default_layout()
        -- Check if Neo-tree is available and preferred
        if pcall(require, "neo-tree") then
          vim.cmd("Neotree filesystem reveal_force_cwd")
        else
          -- Fallback to nvim-tree if neo-tree is not available
          vim.cmd("NvimTreeToggle")
        end

        -- Open README.md if it exists, otherwise open a new buffer
        local readme_path = vim.fn.getcwd() .. "/README.md"
        if vim.fn.filereadable(readme_path) == 1 then
          vim.cmd("edit " .. readme_path)
        else
          vim.cmd("enew")
        end
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
          if vim.fn.argc() == 0 and vim.fn.input("Open default layout? (y/n): ") == "y" then
            open_default_layout()
          end
        end,
      })
    end,
  },
}
