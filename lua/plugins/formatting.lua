-- Formatting using dprint
return {
  {
    "dprint/dprint-vim",
    event = "BufWritePre",
    config = function()
      vim.g.dprint_auto_init = 1
      vim.g.dprint_format_on_save = 1
    end,
  },
}
