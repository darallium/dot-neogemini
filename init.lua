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

require("lazy").setup({
  "plugins",
  "plugins.startup_layout",
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

