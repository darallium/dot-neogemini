return {
  {	
		"catppuccin/nvim",
		name = "catppuccin",
		opts = true,
		lazy = false,
		config = function()
			vim.cmd([[ colorscheme catppuccin ]])
		end,
  },
}
