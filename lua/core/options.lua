---@diagnostic disable: unused-local

---@class GlobalModule
---@field is_windows boolean
---@field is_mac boolean
---@field is_linux boolean
---@field is_wsl boolean
---@field data_dir string
---@field cache_dir string
---@field state_dir string
---@field run_dir string
---@field log_dir string
---@field config_dir string
---@field backup_dir string
---@field undo_dir string

---@type GlobalModule
local global = require('core.global')

---@class VimOptions
---@field whichwrap string
---@field termguicolors boolean
---@field scrolloff integer
---@field encoding string
---@field fileencoding string
---@field fileencodings string
---@field expandtab boolean
---@field shiftwidth integer
---@field softtabstop integer
---@field tabstop integer
---@field autoindent boolean
---@field number boolean
---@field numberwidth integer
---@field relativenumber boolean
---@field signcolumn string
---@field completeopt string
---@field clipboard string
---@field wildignorecase boolean
---@field ignorecase boolean
---@field smartcase boolean
---@field hlsearch boolean
---@field incsearch boolean
---@field inccommand string
---@field autoread boolean
---@field backup boolean
---@field backupdir string
---@field writebackup boolean
---@field undofile boolean
---@field undodir string

---@type VimOptions
local global_local = {
	-- みため
	whichwrap = "b,s,h,l,<,>,[,],~",
	--noshowmode = true,
	termguicolors = true,

	-- scroll
	scrolloff = 4,

	-- encoding
	encoding = "utf-8",
	fileencoding = "utf-8",
	fileencodings = "utf-8, cp932, euc-jp",

	-- tabs = インデント
	expandtab = true,
	shiftwidth = 2,
	softtabstop = 2,
	tabstop = 2,
	autoindent = true,

	-- 行番号
	number = true,
	numberwidth = 2,
	relativenumber = true,
	signcolumn = "yes:1",

	-- 保管
	completeopt = "menuone,noinsert",

	-- clipboard, register
	clipboard = "unnamedplus",

	-- 補完
	wildignorecase = true,

	-- 検索
	ignorecase = true,
	smartcase = true,
	hlsearch = true,
	incsearch = true,
	inccommand = "split",

	-- ファイル操作
	autoread = true,

	-- cache, backup, undo
	backup = true,
	backupdir = global.backup_dir,
	writebackup = false,
	undofile = true,
	undodir = global.undo_dir,
}

---@class GlobalVimOptions
---@field netrw_liststyle integer

---@type GlobalVimOptions
local global_opts = {
	netrw_liststyle = 3,
}

for key, value in pairs(global_local) do
	vim.o[key] = value
end

for key, value in pairs(global_opts) do
	vim.g[key] = value
end

if global.is_wsl then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --crlf",
			["*"] = "win32yank.exe -o --crlf",
		},
	}
end

if global.is_mac then
	vim.g.clipboard = {
		name = 'macOS-clipboard',
		copy = {
			['+'] = 'pbcopy',
			['*'] = 'pbcopy',
		},
		paste = {
			['+'] = 'pbpaste',
			['*'] = 'pbpaste',
		},
		cache_enabled = 0,
	}
end