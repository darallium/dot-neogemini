-- plugins/ui.lua
return {
  -- カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
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
      ---@type CatppuccinOptions
      local catppuccin_opts = opts
      require("catppuccin").setup(catppuccin_opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  
  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true,
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
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
        lualine_x = {'encoding', 'fileformat', 'filetype', 'lsp_client'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location', 'filetype'},
        lualine_y = {},
        lualine_z = {}
      },
    },
  },
  
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
      ---@type NotifyOptions
      local notify_opts = opts
      require("notify").setup(notify_opts)
      vim.notify = require("notify")
    end,
  },
  
  -- フローティングコマンドライン
  {
    "VonHeikemen/fine-cmdline.nvim",
    keys = {
      {
        ":",
        "<cmd>FineCmdline<CR>",
        desc = "Fine cmdline"
      },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = {
        enable_keymaps = true,
        smart_history = true,
        prompt = ': '
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

  -- バッファライン
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>bp",
        "<cmd>BufferLineTogglePin<cr>",
        desc = "Toggle pin"
      },
      {
        "<leader>bP",
        "<cmd>BufferLineGroupClose ungrouped<cr>",
        desc = "Delete non-pinned buffers"
      },
      {
        "<leader>bo",
        "<cmd>BufferLineCloseOthers<cr>",
        desc = "Delete other buffers"
      },
      {
        "<leader>bd",
        "<cmd>BufferLineCloseRight<cr>",
        desc = "Delete buffers to the right"
      },
      {
        "<leader>bc",
        "<cmd>BufferLineCloseLeft<cr>",
        desc = "Delete buffers to the left"
      },
      {
        "<Tab>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next buffer"
      },
      {
        "<S-Tab>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Previous buffer"
      },
    },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "slant",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diagnostics_dict, _) 
          local s = ""
          for e, n in pairs(diagnostics_dict) do
            local icon = e == "error" and " " or (e == "warn" and " " or " ")
            s = s .. icon .. n
          end
          return s
        end,
        offsets = { {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        } },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
      },
    },
  },

  -- ファイルエクスプローラー
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      open_on_setup = false,
      ignore_ft_on_setup = {
        "dashboard",
        "startify",
        "alpha",
      },
      auto_close = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      view = {
        width = 30,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          git_placement = "before",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { "node_modules", ".git" },
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "terminal", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
      },
    },
  },

  -- インデントスコープ
  {
    "echasnovski/mini.indentscope",
    version = false,
    opts = {
      draw = {
        delay = 0,
        priority = 100,
      },
      options = {
        try_as_border = true,
      },
    },
  },

  -- カラー表示
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      user_default_options = {
        RGB = true, -- #RGB
        RRGGBB = true, -- #RRGGBB
        names = false, -- Green
        RRGGBBAA = true, -- #RRGGBBAA
        AARRGGBB = true, -- 0xAARRGGBB
        rgb_fn = true, -- CSS rgb(red, green, blue)
        hsl_fn = true, -- CSS hsl(hue, saturation, lightness)
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS color functions: rgb_fn, hsl_fn
        mode = "virtualtext", -- | background | virtualtext
      },
      color_filetypes = {
        "css",
        "scss",
        "html",
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "json",
      },
    },
  },
}