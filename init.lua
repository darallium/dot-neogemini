---@class LazyPerformanceCache
---@field enabled boolean

---@class LazyPerformanceRtp

---@class LazyPerformance
---@field cache LazyPerformanceCache
---@field rtp LazyPerformanceRtp

---@class LazyDefaults
---@field lazy boolean

---@class LazyRocks
---@field enabled boolean

---@class LazySetupOpts
---@field defaults LazyDefaults
---@field performance LazyPerformance
---@field rocks LazyRocks
---@field lockfile string

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("core")

--require("keymap")

---@type LazySetupOpts
require("lazy").setup({
  { import = "plugins" },
}, {
  defaults = {
    lazy = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {

    }
  },
  rocks = {
    enabled = false,
  },
  lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
})


vim.notify('Neovim configuration loaded successfully!', vim.log.levels.INFO)

return 'hello'

