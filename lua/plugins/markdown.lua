---@class RenderMarkdownLatexOpts
---@field enabled boolean

---@class RenderMarkdownHtmlOpts
---@field enabled boolean

---@class RenderMarkdownPluginOpts
---@field latex RenderMarkdownLatexOpts
---@field html RenderMarkdownHtmlOpts

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@type RenderMarkdownPluginOpts
    opts = {
      latex = { enabled = false },
      html = { enabled = false },
    },
  },
}