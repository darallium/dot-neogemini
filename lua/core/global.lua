---@class GlobalModule
---@field is_mac boolean
---@field is_linux boolean
---@field is_windows boolean
---@field is_wsl boolean
---@field vim_path string
---@field home string
---@field cache_dir string
---@field modules_dir string
---@field data_dir string
---@field backup_dir string
---@field undo_dir string
---@field load_variables fun(self: GlobalModule): nil

---@type GlobalModule
local global = {}

---@type string
local os_name = vim.loop.os_uname().sysname

function global:load_variables()
	self.is_mac = os_name == "Darwin"
	self.is_linux = os_name == "Linux"
	self.is_windows = os_name == "Windows_NT"
	self.is_wsl = vim.fn.has("wsl") == 1
	self.vim_path = vim.fn.stdpath("config")
	---@type string
	local home = self.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")
	self.cache_dir = vim.fs.joinpath(home, ".cache", "nvim", "cache")
	self.modules_dir = vim.fs.joinpath(self.vim_path, "modules")
	self.home = home
	self.data_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
	self.backup_dir = vim.fs.joinpath(home, ".cache", "nvim", "backup")
	self.undo_dir = vim.fs.joinpath(home, ".cache", "nvim", "undo")
end

global:load_variables()

return global