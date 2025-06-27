-- Real-time collaboration using instant.nvim
return {
  {
    "jbyuki/instant.nvim",
    cmd = { "InstantStart", "InstantJoin", "InstantLeave" },
    config = function()
      require("instant").setup({
        -- add your configuration here
      })
    end,
  },
}
