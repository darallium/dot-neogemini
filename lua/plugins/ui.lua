-- plugins/ui.lua
local util = require("util")

return {
  -- カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      integrations = {
        telescope = true,
        treesitter = true,
        cmp = true,
        gitsigns = true,
        notify = true,
        mini = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  
  ---@class LualineOptions
---@field theme string
---@field component_separators table
---@field section_separators table
---@field globalstatus boolean

---@class LualineSection
---@field lualine_a table
---@field lualine_b table
---@field lualine_c table
---@field lualine_x table
---@field lualine_y table
---@field lualine_z table

---@class LualinePluginOpts
---@field options LualineOptions
---@field sections LualineSection
---@field inactive_sections LualineSection

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    ---@type LualinePluginOpts
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true,
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {
          {
            'branch',
            icon = util.icons.git.branch,
          },
          {
            'diff',
            symbols = {
              added = util.icons.git.plus,
              modified = util.icons.git.minus,
              removed = util.icons.git.removed,
            },
          },
          {
            'diagnostics',
            symbols = {
              error = util.icons.diagnostics.Error,
              warn = util.icons.diagnostics.Warn,
              info = util.icons.diagnostics.Info,
            },
          },
        },
        lualine_c = {
          {
            'filename',
            path = 1,
            symbols = {
              modified = '●',
              readonly = '',
              unnamed = '[No Name]',
            }
          }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
    },
  },

  ---@class NavicLspOpts
---@field auto_attach boolean
---@field preference any

---@class NavicPluginOpts
---@field lsp NavicLspOpts
---@field highlight boolean
---@field separator string
---@field depth_limit integer
---@field icons table

  -- winbar
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    ---@type NavicPluginOpts
    opts = function()
      return {
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = true,
        separator = util.icons.ui.arrow_right,
        depth_limit = 5,
        icons = util.icons.kind,
      }
    end,
    config = function(_, opts)
      require("nvim-navic").setup(opts)
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },

  ---@class MiniMapIntegrations
---@field gitsigns table
---@field builtin_search table

---@class MiniMapSymbols
---@field encode any
---@field scroll_line string

---@class MiniMapWindow
---@field focusable boolean
---@field width integer
---@field winblend integer
---@field zindex integer

---@class MiniMapPluginOpts
---@field integrations MiniMapIntegrations
---@field symbols MiniMapSymbols
---@field window MiniMapWindow

  -- scrollbar
  {
    "echasnovski/mini.map",
    event = "VeryLazy",
    ---@type MiniMapPluginOpts
    config = function()
      require("mini.map").setup({
        -- Highlight integrations. Other integrations can be used (see `:h mini.map-integrations`).
        integrations = {
          require("mini.map").gen_integration.gitsigns(),
          require("mini.map").gen_integration.builtin_search(),
        },

        -- Symbols used to display data. See `:h mini.map-symbols`.
        symbols = {
          encode = nil,
          scroll_line = "█",
        },

        -- Window options. See `:h mini.map-window`.
        window = {
          focusable = false,
          width = 20,
          winblend = 15,
          zindex = 10,
        },
      })
    end,
  },
  
  ---@class NvimNotifyPluginOpts
---@field timeout integer
---@field max_height fun(): integer
---@field max_width fun(): integer
---@field on_open fun(win: integer)

  -- 通知
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    ---@type NvimNotifyPluginOpts
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
  
  ---@class FineCmdlineCmdlineOpts
---@field enable_keymaps boolean
---@field smart_history boolean
---@field prompt string

---@class FineCmdlinePopupPosition
---@field row string
---@field col string

---@class FineCmdlinePopupSize
---@field width string

---@class FineCmdlinePopupBorder
---@field style string

---@class FineCmdlinePopupWinOptions
---@field winhighlight string

---@class FineCmdlinePopupOpts
---@field position FineCmdlinePopupPosition
---@field size FineCmdlinePopupSize
---@field border FineCmdlinePopupBorder
---@field win_options FineCmdlinePopupWinOptions

---@class FineCmdlinePluginOpts
---@field cmdline FineCmdlineCmdlineOpts
---@field popup FineCmdlinePopupOpts

  -- フローティングコマンドライン
  {
    "VonHeikemen/fine-cmdline.nvim",
    keys = {
      { ":", "<cmd>FineCmdline<CR>", desc = "Fine cmdline" },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
    ---@type FineCmdlinePluginOpts
    opts = {
      cmdline = {
        enable_keymaps = true,
        smart_history = true,
        prompt = util.icons.ui.ArrowRight .. ' '
      },
      popup = {
        position = {
          row = '10%',
          col = '50%',
        },
        size = {
          width = '60%',
        },
        border = {
          style = 'rounded',
        },
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
    },
  },

  ---@class IndentBlanklineIndentOpts
---@field char string
---@field tab_char string

---@class IndentBlanklineScopeOpts
---@field enabled boolean
---@field show_start boolean
---@field show_end boolean

---@class IndentBlanklinePluginOpts
---@field indent IndentBlanklineIndentOpts
---@field scope IndentBlanklineScopeOpts

  -- インデントライン
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    ---@type IndentBlanklinePluginOpts
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
      },
    },
  },

  ---@class BufferlineDiagnosticsIndicator
---@field count integer
---@field level string
---@field diagnostics_dict table
---@field context table

---@class BufferlineOffset
---@field filetype string
---@field text string
---@field text_align string
---@field separator boolean

---@class BufferlineOptions
---@field mode string
---@field numbers string
---@field diagnostics string
---@field diagnostics_indicator fun(count: integer, level: string, diagnostics_dict: table, context: table): string
---@field offsets BufferlineOffset[]
---@field show_buffer_close_icons boolean
---@field show_close_icon boolean
---@field separator_style string

---@class BufferlinePluginOpts
---@field options BufferlineOptions

  -- バッファライン
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@type BufferlinePluginOpts
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          local icons = util.icons.diagnostics
          for e, n in pairs(diagnostics_dict) do
            local sym = icons[e] or ""
            s = s .. n .. sym .. " "
          end
          return s
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true
          }
        },
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = "thin",
      }
    }
  },

  -- ファイルアイコン
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },

  ---@class WhichKeySpellingOpts
---@field enabled boolean
---@field suggestions integer

---@class WhichKeyPluginsOpts
---@field marks boolean
---@field registers boolean
---@field spelling WhichKeySpellingOpts

---@class WhichKeyWinOpts
---@field border string
---@field padding table

---@class WhichKeyLayoutOpts
---@field height table
---@field width table
---@field spacing integer
---@field align string

---@class WhichKeyPluginOpts
---@field plugins WhichKeyPluginsOpts
---@field win WhichKeyWinOpts
---@field layout WhichKeyLayoutOpts

  -- キーマップヒント
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@type WhichKeyPluginOpts
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      win = {
        border = "rounded",
        padding = { 1, 2, 1, 2 },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },

  ---@class DressingInputOpts
---@field enabled boolean
---@field default_prompt string
---@field win_options table

---@class DressingSelectTelescopeOpts
---@field layout_config table

---@class DressingSelectOpts
---@field enabled boolean
---@field backend string[]
---@field telescope DressingSelectTelescopeOpts

---@class DressingPluginOpts
---@field input DressingInputOpts
---@field select DressingSelectOpts

  -- UIコンポーネント
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    ---@type DressingPluginOpts
    opts = {
      input = {
        enabled = true,
        default_prompt = "Input: ",
        win_options = {
          winblend = 10,
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        telescope = {
          layout_config = {
            height = 0.4,
            width = 0.6,
          },
        },
      },
    },
  },
}
