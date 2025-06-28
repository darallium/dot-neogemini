---@class UtilModule
---@field icons UtilIcons
---@field on_attach fun(callback: fun(client: vim.lsp.Client, buffer: integer)): nil
local M = {}

---@class UtilIcons
---@field modes table<string, string>
---@field diagnostics table<string, string>
---@field git table<string, string>
---@field kinds table<string, string>
---@field ui table<string, string>
M.icons = {
	modes = {
		n = " ",
		i = " ",
		c = " ",
		v = "󰈈 ",
		V = "󰈈 ",
		t = " ",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
		untracked = " ",
		branch = " branch",
		diff = " ",
		plus = " ",
		minus = " ",
		arrow_right = " ",
	},
	kinds = {
		Array = " ",
		Boolean = " ",
		Class = " ",
		Color = " ",
		Constant = " ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = " ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = " ",
		Module = " ",
		Namespace = " ",
		Null = " ",
		Number = " ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = " ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = " ",
	},
	ui = {
		-- General
		Arrow = "➜",
		BoldArrow = "🠖",
		Dot = "●",
		Tilde = "~",
		-- Misc
		Gear = "⚙",
		Package = "󰏖",
		Plug = " plug",
		-- Git
		Git = "",
		GitFork = "",
		GitBranch = "",
		GitCommit = "",
		GitAdd = "",
		GitChange = "",
		GitDelete = "",
		GitUntracked = "",
		GitMerge = "",
		-- LSP
		Lightbulb = "💡",
		-- Diagnostics
		Error = "",
		Warning = "",
		Info = "",
		Hint = "",
		-- File
		File = "",
		FileAdd = "",
		FileRemove = " trash",
		Folder = "",
		FolderOpen = "",
		FolderNew = "",
		-- Search
		Search = "",
		SearchReplace = "",
		-- Window
		Close = "",
		Split = "bel",
		VSplit = "bel",
		-- Other
		DAP = "",
		Debug = "",
		Terminal = "",
		Check = "",
		Cross = "",
		Coffee = "",
		Robot = "🤖",
		Sync = "DB",
		Box = "📦",
		Settings = " настройки",
		Table = "",
		Calendar = "",
		Watch = "",
		Zap = "⚡",
		List = "",
		New = "",
		Note = "📝",
		Pencil = " pencil",
		Rule = "📏",
		Dashboard = "",
		History = "",
		Comment = "",
		Bug = "",
		Run = "",
		SyncFile = "DB",
		ArrowRight = "➜",
		ArrowLeft = "",
		ArrowDown = "",
		ArrowUp = "",
		Ellipsis = "…",
		Plus = "",
		Minus = "",
		DotFill = "●",
		LineLeft = "▎",
		LineRight = "▎",
		Line = "─",
		LineVert = "│",
		LineCorner = "└",
		LineCornerUp = "┌",
		LineCornerDown = "┘",
		LineCornerLeft = "┐",
		LineCornerRight = "├",
		LineCross = "┼",
		LineTee = "┬",
		LineTeeLeft = "┤",
		LineTeeRight = "├",
		LineTeeUp = "┴",
		LineTeeDown = "┬",
		LineDouble = "═",
		LineDoubleVert = "║",
		LineDoubleCorner = "╚",
		LineDoubleCornerUp = "╔",
		LineDoubleCornerDown = "╝",
		LineDoubleCornerLeft = "╗",
		LineDoubleCornerRight = "╠",
		LineDoubleCross = "╬",
		LineDoubleTee = "╦",
		LineDoubleTeeLeft = "╣",
		LineDoubleTeeRight = "╠",
		LineDoubleTeeUp = "╩",
		LineDoubleTeeDown = "╦",
	},
}

---@param on_attach fun(client: vim.lsp.Client, buffer: integer): nil
M.on_attach = function(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			---@type integer
			local buffer = args.buf
			---@type vim.lsp.Client|nil
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

return M
