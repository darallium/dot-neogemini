---@class CatppuccinPluginOpts
---@field flavour string
---@field background table
---@field transparent_background boolean
---@field show_end_of_buffer boolean
---@field term_colors boolean
---@field dim_inactive table
---@field integrations table

return {
  {	
		"catppuccin/nvim",
		name = "catppuccin",
		---@type CatppuccinPluginOpts
		opts = {
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
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
		lazy = false,
		config = function()
			vim.cmd([[ colorscheme catppuccin ]])
		end,
  },
}
